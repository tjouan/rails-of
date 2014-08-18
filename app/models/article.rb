class Article < ActiveRecord::Base
  BODY_SUM_LENGHT = 32
  BODY_SUM_APPEND = '(…)'.freeze

  validates :zone, presence: true
  validates :body, presence: true


  def to_s
    '%s: %s' % [zone, body_sum]
  end

  def body_sum
    [
      body[0..BODY_SUM_LENGHT][/(.*)\s/m, 1],
      BODY_SUM_APPEND
    ].join
  end
end
