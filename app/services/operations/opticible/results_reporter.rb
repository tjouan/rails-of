module Operations
  class Opticible
    class ResultsReporter
      attr_reader :probs

      def initialize(probs)
        @probs = probs
      end

      def distribution
        probs_by_interval.each_with_object({}) do |(k, v), m|
          m[k] = v.size
        end
      end

      def min
        sorted_probs.first
      end

      def max
        sorted_probs.last
      end

      def mean
        probs.inject(0.0) { |m, e| m + e } / probs.size
      end

      def means
        probs_by_interval(intervals: 10).each_with_object({}) do |(k, v), m|
          m[k] = v.inject(0.0) { |m, e| m + e } / v.size
        end
      end

      def means_accumulated
        ps = Hash[probs_by_interval(intervals: 10).to_a.reverse]
        ps.each_with_object({}) do |(k, v), m|
          m[k] = v.inject(0.0) { |m, e| m + e } / v.size
          means_up = (k..9).map { |e| m[e] }.compact
          next unless means_up.size >= 2
          m[k] = [m[k], *means_up].inject(0.0) { |m, e| m + e } / (means_up.size + 1)
        end
      end

      def probs_by_interval(intervals: 100)
        range_size = (sorted_probs.last - sorted_probs.first) / intervals
        sorted_probs.group_by do |e|
          index = ((e - sorted_probs.first) / range_size).to_i
          index -= 1 if index >= intervals
          index
        end
      end

      def sorted_probs
        @sorted_probs ||= probs.sort
      end
    end
  end
end
