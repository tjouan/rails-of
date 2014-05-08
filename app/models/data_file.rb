class DataFile < ActiveRecord::Base
  require 'fileutils'

  def path
    File.join(Rails.configuration.data_files_path, id.to_s)
  end

  def file=(file)
    FileUtils.cp file.path, path
    self.mime_type = file.content_type
  end
end
