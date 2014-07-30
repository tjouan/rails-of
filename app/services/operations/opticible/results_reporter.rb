module Operations
  class Opticible
    class ResultsReporter
      SLICES = 10.freeze

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

      def slice_size
        sliced_probs.first.size
      end

      def means
        sliced_probs.map do |ps|
          ps.inject(0.0) { |m, e| m + e } / ps.size
        end
      end

      def means_accumulated
        means.reverse.each_with_object([]) do |mean, m|
          if m.any?
            m << [*m, mean].inject(0.0) { |m, e| m + e } / (m.size + 1)
          else
            m << mean
          end
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

      def sliced_probs
        @sliced_probs ||= begin
          sorted_probs.each_slice(probs.size / SLICES).to_a.tap do |e|
            e[e.size - 2] += e.pop
          end
        end
      end
    end
  end
end
