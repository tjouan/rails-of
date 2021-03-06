class Header < ActiveRecord::Base
  TYPES = {
    text:     'texte',
    longtext: 'texte long',
    int:      'entier',
    float:    'flottant',
    date:     'date'
  }.freeze

  # in order to use type as a column name.
  self.inheritance_column = nil

  belongs_to :source

  enum type: TYPES.keys

  validates :position,  presence: true
  validates :name,      presence: true
  validates :type,      presence: true


  def to_s
    '#%d %s:%s,%d (#%d)' % [id, name, type, position, source_id]
  end

  def type_description
    TYPES[type.to_sym]
  end

  def value_sample
    source.line_sample[position]
  end
end
