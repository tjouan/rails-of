module Operations
  class Opticible
    class FinancialEvaluation
      attr_reader :cost, :margin, :expectations

      def initialize(cost, margin, expectations)
        @cost         = cost
        @margin       = margin
        @expectations = expectations
      end

      def report
        {
          cost:               cost,
          margin:             margin,
          optimal_rate:       cost / margin,
          count_before:       expectations.size,
          count_after:        expectations_after.size,
          cost_before:        cost_before,
          cost_after:         cost_after,
          rate_after:         rate_after,
          margin_before:      margin_before,
          margin_after:       margin_after,
          margin_rate_before: margin_before / cost_before,
          margin_rate_after:  margin_after / cost_after,
          margin_gain:        margin_after - margin_before
        }
      end

      def expectations_after
        @expectations_after ||= expectations.select { |e| e.last > 0 }
      end

      def cost_before
        @cost_before ||= expectations.size * cost
      end

      def cost_after
        @cost_before ||= expectations_after.size * cost
      end

      def rate_after
        expectations_after.inject(0.0) do |m, e|
          m + e.first
        end / expectations_after.size
      end

      def margin_before
        @margin_before ||= expectations.map(&:last).sum
      end

      def margin_after
        @margin_after ||= expectations_after.map(&:last).sum
      end
    end
  end
end
