module Operations
  class Opticible
    include Backburner::Logger

    TMPDIR_PATTERN    = 'opticible'.freeze
    COLUMN_ARG_FORMAT = 'col%d'.freeze
    COLUMN_IDENT      = 'col0'.freeze
    TRAIN_FILE_PATH   = 'train.csv'.freeze
    TARGET_FILE_PATH  = 'target.csv'.freeze
    LEVEL_BASE        = 1
    LEVEL_PLUS        = 2

    attr_accessor :work
    attr_reader   :input, :output, :params

    def initialize(input, params, output, ignore_lines: 0)
      @input        = input
      @output       = output
      @params       = params
      @ignore_lines = ignore_lines
    end

    def process!
      log_info "WORK: ##{work.id}"
      Dir.mktmpdir(TMPDIR_PATTERN) do |dir|
        prepare_sources dir
        Dir.chdir(dir) do
          execution.run
        end
      end
    end

    def execution
      @execution ||= Execution.new(execution_arguments)
    end

    def execution_arguments
      [
        LEVEL_BASE,
        TRAIN_FILE_PATH,
        TARGET_FILE_PATH,
        COLUMN_IDENT,
        column_argument(params[0]),
        column_argument(params[1]),
        column_argument(columns_for('date')),
        column_argument(columns_for('longtext')),
        nil
      ]
    end

    def column_argument(param)
      param.split(',').map(&:to_i).map do |e|
        COLUMN_ARG_FORMAT % (e + 1)
      end.join ','
    end

    def columns_for(type)
      work.source.headers.select { |h| h.type == type }.map(&:position).join(',')
    end

    def prepare_sources(dir)
      train_id_last = prepare_source work.source, File.join(dir, TRAIN_FILE_PATH)

      prepare_source work.target_source, File.join(dir, TARGET_FILE_PATH),
        id_start: train_id_last + 1
    end

    def prepare_source(source, path, id_start: 0)
      log_info "source: ##{source.id} `#{source.label}'"
      id = nil

      CSV.open(path, 'w') do |out|
        out << header = (source.headers.count + 1).times.inject([]) do |m, e|
          m << COLUMN_ARG_FORMAT % e
        end
        source.rows.each_with_index do |r, i|
          id = id_start + i
          out << [id, *r]
        end
      end
      id
    end
  end
end
