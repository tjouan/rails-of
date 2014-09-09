class Offer < ActiveRecord::Base
  def to_s
    '%s %s' % [ref, price ? '(%.2f)' % price : nil]
  end
end
