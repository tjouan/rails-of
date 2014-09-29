class Offer < ActiveRecord::Base
  scope :visible, -> { where visible: true }


  def to_s
    '%s %s' % [ref, price ? '(%.2f)' % price : nil]
  end
end
