class ExportDestroyer
  def initialize(export)
    @export = export
  end

  def call
    @export.destroy
    File.delete(@export.path) unless Export.exists?(sha256: @export.sha256)
  end
end
