class SourceDestroyer
  def initialize(source)
    @source = source
  end

  def call
    @source.destroy
    File.delete(@source.path) unless Source.exists?(sha256: @source.sha256)
  end
end
