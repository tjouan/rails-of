class Source < ActiveRecord::Base
  HEADER_PLACEHOLDER    = 'Champ %d'.freeze
  CHARSET_CHECK_LENGTH  = 500 * (10 ** 3)

  has_many :headers, dependent: :destroy
  accepts_nested_attributes_for :headers

  has_many :works, dependent: :destroy

  before_create :set_default_label

  validates_presence_of :sha256

  validate :charset_must_be_supported


  def set_default_label
    self.label = file_name if label.blank? || label.nil?
  end

  def charset_must_be_supported
    return unless sha256

    sample = File.new(path).read(CHARSET_CHECK_LENGTH)
    sample.force_encoding 'utf-8'
    unless sample.valid_encoding?
      errors.add :charset, 'impossible de détecter le jeu de caractères'
    end
  end

  def path
    File.join(Rails.configuration.sources_path, sha256)
  end

  def file=(file)
    return unless file

    self.sha256 = Digest::SHA256.file(file.path).hexdigest
    FileUtils.cp file.path, path
    self.file_name = Pathname.new(file.original_filename).to_s
    self.mime_type = file.content_type
  end

  def header?
    headers.any?
  end

  def detect_headers!(from_file = false)
    if from_file
      file_header.each { |e| headers.build name: e }
    else
      file.shift.each_with_index do |e, k|
        headers.build name: HEADER_PLACEHOLDER % [k + 1]
      end
    end
  end

  def file_header
    file.shift
  end

  private

  def file
    CSV.new(File.new(path))
  end
end
