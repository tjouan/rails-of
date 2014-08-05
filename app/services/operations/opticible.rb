module Operations
  class Opticible
    include Backburner::Logger

    TMPDIR_PATTERN        = 'opticible'.freeze
    COLUMN_ARG_FORMAT     = 'col%d'.freeze
    COLUMN_IDENT          = 'col0'.freeze
    TRAIN_FILE_PATH       = 'train.csv'.freeze
    TARGET_FILE_PATH      = 'target.csv'.freeze
    LEVEL_BASE            = 1
    LEVEL_PLUS            = 2
    TRAIN_LEVEL_BASE      = 0
    TRAIN_LEVEL_FULL      = 1
    SEED_BASE             = 0
    SEED_RANDOM           = 1
    OUT_TRAIN_TRAIN_PATH  = 'sc_train_train'.freeze
    OUT_TRAIN_TEST_PATH   = 'sc_train_test'.freeze
    OUT_TEST_PROB_PATH    = 'sc_test_prob'.freeze

    attr_accessor :work
    attr_reader   :input, :output, :target, :ignores, :test_probs, :correction

    def initialize(input, params, output, ignore_lines: 0)
      @input        = input
      @output       = output
      @target       = params[0].to_i
      @ignores      = params[1]
      @ignore_lines = ignore_lines
      @test_probs   = []
      @correction   = nil
    end

    def process!
      log_info "WORK: ##{work.id}"
      Dir.mktmpdir(TMPDIR_PATTERN) do |dir|
        prepare_sources dir
        rows_test = work.target_source.rows
        target_rate_train = adjust_target_rate_train
        Dir.chdir(dir) do
          execution.run
          @correction = target_rate_train / adjust_target_rate_real
          output_results(rows_test, correction)
        end
      end
    end

    def results_report
      reporter = ResultsReporter.new(test_probs)
      {
        correction:   correction,
        min:          reporter.min,
        max:          reporter.max,
        mean:         reporter.mean,
        distribution: reporter.distribution,
        slice_size:   reporter.slice_size,
        means:        reporter.means,
        means_acc:    reporter.means_accumulated
      }
    end

    def output_results(rows, correction)
      log_info 'OUTPUT correction: %f' % correction
      results = CSV.open(OUT_TEST_PROB_PATH).tap(&:shift)

      CSV(output) do |o|
        results.each do |r|
          prob = r.last
          prob_corrected = prob.to_f * correction
          prob_corrected = 1 - Float::EPSILON if prob_corrected > 1.0
          o << [*rows.shift, prob, prob_corrected]
          @test_probs << prob_corrected
        end
      end
    end

    def adjust_target_rate_train
      total_count = 0

      truthy_target_count = work.source.rows.inject(0) do |m, r|
        m += 1 if r[target] == '1'
        total_count += 1
        m
      end

      truthy_target_count.fdiv total_count
    end

    def adjust_target_rate_real
      total_count         = 0
      truthy_target_count = 0

      [OUT_TRAIN_TRAIN_PATH, OUT_TRAIN_TEST_PATH].each do |p|
        i = CSV.open(p).tap(&:shift)
        truthy_target_count += i.inject(0) do |m, r|
          m += r.last.to_f
          total_count += 1
          m
        end
      end

      truthy_target_count.fdiv total_count
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
        column_argument(target.to_s),
        column_argument(ignores),
        column_argument(columns_for('date')),
        column_argument(columns_for('longtext')),
        nil,
        TRAIN_LEVEL_BASE,
        SEED_BASE
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
