class Offer < ActiveRecord::Base
  FREE_OFFER_DAY_COUNT  = 15
  ORDER_BY              = %w[bronze silver gold]

  class << self
    def free_offer
      find_by_ref 'free'
    end

    def order_by_case
      ORDER_BY.each_with_object('CASE').with_index do |(e, m), i|
        m << " WHEN ref = '#{e}' THEN #{i}"
      end << ' END'
    end
  end

  scope :visible, -> { where visible: true }

  scope :sorted, -> { order order_by_case }


  def to_s
    '%s %s' % [ref, price ? '(%.2f)' % price : nil]
  end
end
