class Operation < ActiveRecord::Base
  USAGE_MULTIPLIERS = {
    firstnames: 2,
    geoscore:   1,
    insee:      26
  }.freeze

  has_many :works, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :ref

  scope :active, -> { where active: true }


  def to_s
    '#%d %s: %s' % [id, ref, name]
  end

  def usage_multiplier
    USAGE_MULTIPLIERS[ref.to_sym]
  end
end
