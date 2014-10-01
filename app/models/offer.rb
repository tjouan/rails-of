class Offer < ActiveRecord::Base
  FREE_OFFER_DAY_COUNT = 15

  class << self
    def free_offer
      find_by_ref 'free'
    end
  end

  scope :visible, -> { where visible: true }


  def to_s
    '%s %s' % [ref, price ? '(%.2f)' % price : nil]
  end
end
