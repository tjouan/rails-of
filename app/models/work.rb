class Work < ActiveRecord::Base
  belongs_to :user
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

  scope :latest, -> { limit 5 }


  def to_s
    '#%d %s/%s %s (#%d%s)' % [
      id,
      operation.ref,
      status,
      parameters.inspect,
      source_id,
      target_source_id ? ',#%d' % target_source_id : ''
    ]
  end

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

  def parameters_as_headers(index)
    source.headers.where position: parameters[index].split(',').map(&:to_i)
  end

  def parent_source
    target_source or source
  end
end
