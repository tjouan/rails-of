class SourceSaver
  attr_reader :source, :file

  def initialize(source, file)
    @source = source
    @file   = file
  end

  def call
    save_file
    source.set_charset
    update_rows_count
    source.detect_headers!
    source.save
  end

  def save_file
    source.sha256 = Digest::SHA256.file(file.path).hexdigest
    FileUtils.cp file.path, source.path
    source.file_name = Pathname.new(file.original_filename).to_s
    source.mime_type = file.content_type
  end


  private

  def update_rows_count
    source.rows_count = source.rows.count
  end
end
