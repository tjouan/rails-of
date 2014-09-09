class SourceDestroyer
  def initialize(source)
    @source = source
  end

  def call
    File.delete(@source.path)
    @source.destroy
  end
end
