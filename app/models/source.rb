class Source < ActiveRecord::Base
  HEADER_PLACEHOLDER = 'Champ %d'.freeze

  has_many :headers, dependent: :destroy
  accepts_nested_attributes_for :headers

  has_many :works, dependent: :destroy

  before_create :set_default_label

  def set_default_label
    self.label = file_name if label.blank? || label.nil?
  end

  def path
    File.join(Rails.configuration.sources_path, sha256)
  end

  def file=(file)
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
