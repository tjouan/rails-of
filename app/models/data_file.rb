class DataFile < ActiveRecord::Base
  require 'fileutils'
  require 'pathname'

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
end
