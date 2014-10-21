class Operation < ActiveRecord::Base
  USAGE_MULTIPLIERS = {
    firstnames: 1,
    geoscore:   2,
    insee:      3
  }

  has_many :works, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :ref


  def to_s
    '#%d %s: %s' % [id, ref, name]
  end

  def usage_multiplier
    USAGE_MULTIPLIERS[ref.to_sym]
  end
end
