module Operations
  class Opticible
    require 'open3'

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
    COLUMN_ARG_FORMAT = 'col%s'.freeze

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
        File.expand_path(work.source.path),
        File.expand_path(work.target_source.path),
        column_argument(params[0]),
        column_argument(params[1]),
        column_argument(params[2]),
        # FIXME: implement last parameters
        nil, nil, nil
      ]
      command
    end

    def column_argument(param)
      param.split(',').map do |e|
        COLUMN_ARG_FORMAT % e
      end.join ','
    end

    def run_command_in_tmp_dir
      Dir.mktmpdir(TMPDIR_PATTERN) do |dir|
        cmd = [
          "R_LIBS=#{R_LIBS}",
          Shellwords.shelljoin(command(dir))
        ].join ' '
        log_info(cmd)
        Dir.chdir(dir) do
          run_command cmd
        end
      end
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
