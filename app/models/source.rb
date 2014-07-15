class Source < ActiveRecord::Base
  HEADER_PLACEHOLDER    = 'Champ %d'.freeze
  CHARSET_CHECK_LENGTH  = (500 * (10 ** 3)).freeze
  CHARSETS              = %w[utf-8 iso-8859-15].freeze
  PREVIEW_SIZE          = 32

  attr_accessor :file

  has_many :headers,
    -> { order 'position ASC' },
    dependent: :destroy
  accepts_nested_attributes_for :headers

  has_many :works, dependent: :destroy

  before_validation :set_charset
  before_create     :set_default_label

  validates_presence_of :sha256
  validates_presence_of :charset


  def path
    File.join(Rails.configuration.sources_path, sha256)
  end

  def to_file
    @file || (sha256 ? File.new(path, encoding: charset) : nil)
  end

  def to_csv
    CSV.new(to_file)
  end

  def first_row
    to_csv.shift
  end

  def header?
    headers.any?
  end

  def detect_headers!(names: false)
    first_row.each_with_index do |e, i|
      headers.build position: i,
        name: names ? e : HEADER_PLACEHOLDER % [i + 1]
    end
  end

  def preview
    c = to_csv
    c.shift if file_header
    c.take PREVIEW_SIZE
  end

  def set_charset
    return unless to_file

    sample = to_file.read(CHARSET_CHECK_LENGTH)
    self.charset = CHARSETS.detect do |e|
      sample.force_encoding(e).valid_encoding? and e
    end
  end

  def set_default_label
    self.label = file_name if label.blank? || label.nil?
  end
end
