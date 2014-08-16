class Source < ActiveRecord::Base
  PREVIEW_SIZE = 32

  belongs_to :user

  has_many :headers,
    -> { order 'position ASC' },
    dependent: :destroy
  accepts_nested_attributes_for :headers

  has_many :works, dependent: :destroy

  before_create :set_default_label

  validates_presence_of :sha256

  default_scope { order('created_at DESC') }


  def to_s
    '#%d %s (#%d)' % [id, label, user_id]
  end

  def path
    File.join(Rails.configuration.sources_path, sha256)
  end

  def rows
    to_csv
  end

  def line_sample
    rows.shift
  end

  def preview(count = PREVIEW_SIZE)
    rows.take count
  end

  def set_default_label
    self.label = file_name if label.blank? || label.nil?
  end

  def headers_by_type(type)
    headers.select { |e| e.type == type }
  end


  private

  def to_csv
    CSV.new(File.new(path))
  end
end
