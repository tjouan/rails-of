class Header < ActiveRecord::Base
  TYPES = {
    text:   'texte',
    int:    'entier',
    float:  'flottant',
    date:   'date'
  }.freeze

  # in order to use type as a column name.
  self.inheritance_column = nil

  belongs_to :source

  enum type: [:text, :int, :float, :date]

  def type_description
    TYPES[type.to_sym]
  end
end
