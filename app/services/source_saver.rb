class SourceSaver
  attr_reader :source

  def initialize(source)
    @source = source
  end

  def call
    return false unless source.save

    true
  end
end
