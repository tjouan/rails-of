class SourceVersionSaver
  attr_reader :parent, :operation, :file

  def initialize(parent, operation, file, save: true)
    @parent     = parent
    @operation  = operation
    @file       = file
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
    save_file source, @file.path
    source.rows_count = source.rows.count

    source.save if save?
  end


  private

  def label
    "#{@parent.label} enrichi par #{@operation.name}"
  end

  def save_file(source, file_path)
    source.sha256 = Digest::SHA256.file(file_path).hexdigest
    FileUtils.cp file_path, source.path
  end
end
