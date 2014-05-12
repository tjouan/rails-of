class DataFile < ActiveRecord::Base
  require 'fileutils'
  require 'pathname'

  def path
    File.join(Rails.configuration.data_files_path, id.to_s)
  end

  def file=(file)
    FileUtils.cp file.path, path
    self.file_name = Pathname.new(file.original_filename).to_s
    self.mime_type = file.content_type
  end
end
