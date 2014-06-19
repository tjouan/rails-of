class Source < ActiveRecord::Base
  HEADER_PLACEHOLDER    = 'Champ %d'.freeze
  CHARSET_CHECK_LENGTH  = 500 * (10 ** 3)

  attr_accessor :file

  has_many :headers, dependent: :destroy
  accepts_nested_attributes_for :headers

  has_many :works, dependent: :destroy

  before_create :set_default_label

  validates_presence_of :sha256

  validate :charset_must_be_supported


  def path
    File.join(Rails.configuration.sources_path, sha256)
  end

  def to_file
    @file || File.new(path)
  end

  def to_csv
    CSV.new(to_file)
  end

  def file_header
    to_csv.shift
  end

  def header?
    headers.any?
  end

  def detect_headers!(names: false)
    if names
      file_header.each { |e| headers.build name: e }
    else
      file_header.each_with_index do |e, k|
        headers.build name: HEADER_PLACEHOLDER % [k + 1]
      end
    end
  end

  def set_default_label
    self.label = file_name if label.blank? || label.nil?
  end

  def charset_must_be_supported
    return unless sha256

    sample = to_file.read(CHARSET_CHECK_LENGTH)
    sample.force_encoding 'utf-8'
    unless sample.valid_encoding?
      errors.add :charset, 'impossible de détecter le jeu de caractères'
    end
  end
end
