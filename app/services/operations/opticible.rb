module Operations
  class Opticible
    include Backburner::Logger

    DEBUG_VAR             = 'OPTICIBLE_DEBUG'.freeze
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
    attr_reader   :input, :output, :target, :ignores, :cost, :margin
    attr_reader   :correction, :test_probs, :expectations

    def initialize(input, params, output)
      @input        = input
      @output       = output
      @target       = params[0].to_i
      @ignores      = params[1]
      @cost         = !params[2].empty? ? params[2].to_f : nil
      @margin       = !params[3].empty? ? params[3].to_f : nil

      @correction   = nil
      @test_probs   = []
      @expectations = []
    end

    def debug?
      ENV.key? DEBUG_VAR
    end

    def headers
      if debug?
        {
          'raw probability'       => :int,
          'adjusted probability'  => :int
        }
      else
        { 'probability' => :int }
      end
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
          output_results(rows_test)
        end
      end

      output.rewind
    end

    def results_report
      reporter = ResultsReporter.new(test_probs)

      report = {
        correction:   correction,
        min:          reporter.min,
        max:          reporter.max,
        mean:         reporter.mean,
        distribution: reporter.distribution,
        slice_size:   reporter.slice_size,
        means:        reporter.means,
        means_acc:    reporter.means_accumulated
      }

      if cost && margin
        report[:evaluation] = FinancialEvaluation.new(
          cost,
          margin,
          test_probs.zip(expectations)
        ).report
      end

      report
    end

    def output_results(rows)
      log_info 'OUTPUT correction: %f' % correction
      results = CSV.open(OUT_TEST_PROB_PATH).tap(&:shift)

      CSV(output) do |o|
        results.each do |r|
          raw_prob    = r.last.to_f
          prob        = prob_adjust raw_prob
          expectation = prob_to_expectation prob if financial_report?

          values = rows.shift
          values << raw_prob if debug?
          values << prob
          values << expectation if financial_report?

          o             << values
          @test_probs   << prob
          @expectations << expectation if financial_report?
        end
      end
    end

    def financial_report?
      margin && cost
    end

    def prob_adjust(prob)
      prob_adjusted = prob.to_f * correction
      prob_adjusted <= 1.0 ? prob_adjusted : 1 - Float::EPSILON
    end

    def prob_to_expectation(prob)
      margin * prob - cost
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
      work.source.headers_by_type(type).map(&:position).join(',')
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
