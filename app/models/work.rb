class Work < ActiveRecord::Base
  belongs_to :operation
  belongs_to :source
end
