module Operations
  class Opticible
    OpticibleError = Class.new(RuntimeError)

    include Backburner::Logger

    # FIXME: remove env usage and fullpath when opticible can be packaged and
    # installed.
    OPTICIBLE_ROOT    = (ENV.key? 'OPTICIBLE') ?
                          ENV['OPTICIBLE'].dup.freeze :
                          "#{ENV['HOME']}/usr/opticible".freeze
    OPTICIBLE         = "#{OPTICIBLE_ROOT}/bin/opti-r.R".freeze
    R_LIBS            = "#{OPTICIBLE_ROOT}/.vendor".freeze
    LEVEL_BASE        = 1
    LEVEL_PLUS        = 2
    TMPDIR_PATTERN    = 'opticible'.freeze
    COLUMN_ARG_FORMAT = 'col%d'.freeze
    COLUMN_IDENT      = 'col0'.freeze
    TRAIN_FILE_PATH   = 'train.csv'.freeze
    TARGET_FILE_PATH  = 'target.csv'.freeze

    attr_accessor :work
    attr_reader   :input, :output, :params

    def initialize(input, params, output, ignore_lines: 0)
      @input        = input
      @output       = output
      @params       = params
      @ignore_lines = ignore_lines
    end

    def process!
      run_command_in_tmp_dir
    end

    def command(dir)
      command = [
        OPTICIBLE, LEVEL_BASE,
        TRAIN_FILE_PATH,
        TARGET_FILE_PATH,
        COLUMN_IDENT,
        column_argument(params[0]),
        column_argument(params[1]),
        column_argument(columns_for('date')),
        column_argument(columns_for('longtext')),
        nil
      ]
      command
    end

    def column_argument(param)
      param.split(',').map(&:to_i).map do |e|
        COLUMN_ARG_FORMAT % (e + 1)
      end.join ','
    end

    def columns_for(type)
      work.source.headers.select { |h| h.type == type }.map(&:position).join(',')
    end

    def run_command_in_tmp_dir
      Dir.mktmpdir(TMPDIR_PATTERN) do |dir|
        cmd = [
          "R_LIBS=#{R_LIBS}",
          Shellwords.shelljoin(command(dir))
        ].join ' '
        log_info(cmd)
        log_info("SOURCE: ##{work.source.id} `#{work.source.label}'")
        log_info("TARGET: ##{work.target_source.id} `#{work.target_source.label}'")
        prepare_sources(dir)
        Dir.chdir(dir) do
          run_command cmd
        end
      end
    end

    def prepare_sources(dir)
      train_id_last = prepare_source work.source, File.join(dir, TRAIN_FILE_PATH)

      prepare_source work.target_source, File.join(dir, TARGET_FILE_PATH),
        id_start: train_id_last + 1
    end

    def prepare_source(source, path, id_start: 0)
      id = nil
      i = source.to_csv

      CSV.open(path, 'w') do |out|
        out << header = (i.shift.size + 1).times.inject([]) do |m, e|
          m << COLUMN_ARG_FORMAT % e
        end
        i.rewind unless source.file_header?
        i.each_with_index do |r, i|
          id = id_start + i
          out << [id, *r]
        end
      end
      id
    end

    def run_command(cmd)
      exit_status = 0
      Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
        { stdout => output.method(:puts),
          stderr => method(:log_error)
        }.each do |stream, meth|
          while line = stream.gets
            meth.call line.chomp
          end
        end
        exit_status = wait_thr.value.exitstatus
      end
      if exit_status != 0
        fail OpticibleError, "Opticible exited with: #{exit_status}"
      end
    end
  end
end
