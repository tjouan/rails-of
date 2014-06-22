class Work < ActiveRecord::Base
  belongs_to :operation
  belongs_to :source

  validates :operation, presence: true
  validates :source,    presence: true

  # FIXME: validates_presence_of won't work well with an empty array (returns
  # true), and there are no specific validation to test for nil.
  validates :parameters, length: { minimum: 0, allow_nil: false }

  def status
    if processed_at
      :processed
    elsif failed_at
      :error
    elsif terminated_at
      :timeout
    end
  end
end
