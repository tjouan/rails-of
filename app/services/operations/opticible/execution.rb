module Operations
  class Opticible
    class Execution
      Error = Class.new(RuntimeError)

      include Backburner::Logger

      OPTICIBLE_ROOT  = (ENV.key? 'OPTICIBLE') ?
                            ENV['OPTICIBLE'].dup.freeze :
                            "#{ENV['HOME']}/usr/opticible".freeze
      OPTICIBLE       = "#{OPTICIBLE_ROOT}/bin/opti-r.R".freeze
      R_LIBS          = "#{OPTICIBLE_ROOT}/.vendor".freeze

      attr_reader :arguments, :status

      def initialize(arguments)
        @arguments  = arguments
        @status     = nil
      end

      def run
        log_info "`#{command}`"
        Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
          { stdout => method(:log_info),
            stderr => method(:log_error)
          }.each do |stream, meth|
            while line = stream.gets
              meth.call line.chomp
            end
          end

          @status = wait_thr.value.exitstatus
        end

        fail Error, "Opticible exited with: #{exit_status}" unless @status == 0
      end

      def command
        [
          "R_LIBS=#{R_LIBS}",
          Shellwords.shelljoin([OPTICIBLE, *arguments]),
        ].join ' '
      end
    end
  end
end
