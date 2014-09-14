class SourceVersionSaver
  def initialize(parent, operation, file, headers, save: true)
    @parent     = parent
    @operation  = operation
    @file       = file
    @headers    = headers
    @save       = save
  end

  def save?
    @save
  end

  def call
    source = @parent.user.sources.new(
      label:        label,
      description:  @parent.description,
      file_name:    @parent.file_name,
      headers:      @parent.headers.map(&:dup)
    )
    build_extra_headers source
    save_file source, @file.path
    source.rows_count = source.rows.count

    source.save if save?
  end


  private

  def label
    "#{@parent.label} enrichi par #{@operation.name}"
  end

  def build_extra_headers(source)
    @headers.map do |k, v|
      source.append_header k, v
    end
  end

  def save_file(source, file_path)
    source.sha256 = Digest::SHA256.file(file_path).hexdigest
    FileUtils.cp file_path, source.path
  end
end
