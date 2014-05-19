class DataFile < ActiveRecord::Base
  require 'fileutils'
  require 'pathname'
  require 'csv'

  HEADER_PLACEHOLDER = 'Champ %d'.freeze

  TYPES = [
    'chaîne de caractères',
    'entier'
  ].freeze

  def path
    File.join(Rails.configuration.data_files_path, sha256)
  end

  def file=(file)
    self.sha256 = Digest::SHA256.file(file.path).hexdigest
    FileUtils.cp file.path, path
    self.file_name = Pathname.new(file.original_filename).to_s
    self.mime_type = file.content_type
  end

  def file?
    !!sha256
  end

  def editable_header
    return file_header if header
    file.shift.inject({}) do |m, e|
      k = HEADER_PLACEHOLDER % [m.size + 1]
      m[k] = nil
      m
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
