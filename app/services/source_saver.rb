class SourceSaver
  attr_reader :source

  def initialize(source)
    @source = source
  end

  def call
    return false unless save_file!

    save_file!

    return source.save
  end

  def save_file!
    return false unless source.file

    source.sha256 = Digest::SHA256.file(source.file.path).hexdigest
    FileUtils.cp source.file.path, source.path
    source.file_name = Pathname.new(source.file.original_filename).to_s
    source.mime_type = source.file.content_type

    true
  end
end
