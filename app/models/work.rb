class Work < ActiveRecord::Base
  belongs_to :operation
  belongs_to :source
  belongs_to :target_source,
    class_name: 'Source', foreign_key: 'target_source_id'

  validates :operation, presence: true
  validates :source,    presence: true

  # FIXME: validates_presence_of won't work well with an empty array (returns
  # true), and there are no specific validation to test for nil.
  validates :parameters, length: { minimum: 0, allow_nil: false }

  default_scope { order('created_at DESC') }


  def status
    return :queued unless started_at

    if processed_at
      :processed
    elsif failed_at
      :error
    elsif terminated_at
      :timeout
    else
      :processing
    end
  end
end
