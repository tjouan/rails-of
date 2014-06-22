class Operation < ActiveRecord::Base
  has_many :works, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :ref
end
