class Source < ActiveRecord::Base
  HEADER_PLACEHOLDER    = 'Champ %d'.freeze
  CHARSET_CHECK_LENGTH  = (500 * (10 ** 3)).freeze
  CHARSETS              = %w[utf-8 iso-8859-15].freeze
  PREVIEW_SIZE          = 32

  belongs_to :user

  has_many :headers,
    -> { order 'position ASC' },
    dependent: :destroy
  accepts_nested_attributes_for :headers

  has_many :works, dependent: :destroy

  before_create :set_default_label

  validates_presence_of :sha256
  validates_presence_of :charset

  default_scope { order('created_at DESC') }


  def to_s
    '#%d %s %s,%s (#%d)' % [id, label, mime_type, charset, user_id]
  end

  def path
    File.join(Rails.configuration.sources_path, sha256)
  end

  def to_file
    File.new(path, encoding: charset)
  end

  def rows
    to_csv.tap { |e| e.shift if file_header }
  end

  def first_row
    to_csv.shift
  end

  def line_sample
    rows.shift
  end

  def detect_headers!
    first_row.each_with_index do |e, i|
      headers.build position: i,
        name: file_header ? e : HEADER_PLACEHOLDER % [i + 1],
        type: :text
    end
  end

  def preview(count = PREVIEW_SIZE)
    rows.take count
  end

  def set_charset
    sample = to_file.read(CHARSET_CHECK_LENGTH)
    self.charset = CHARSETS.detect do |e|
      sample.force_encoding(e).valid_encoding?
    end
  end

  def set_default_label
    self.label = file_name if label.blank? || label.nil?
  end

  def headers_by_type(type)
    headers.select { |e| e.type == type }
  end


  private

  def to_csv
    CSV.new(to_file)
  end
end
