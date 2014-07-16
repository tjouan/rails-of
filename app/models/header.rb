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

  def type_description
    TYPES[type.to_sym]
  end

  def value_sample
    csv = source.to_csv
    csv.shift if source.file_header?
    csv.shift[position]
  end
end
