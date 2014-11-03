class ExportSaver
  class << self
    def perform(export_id)
      new(Export.find(export_id)).export
    end
  end

  def initialize(export)
    @export = export
  end

  def call
    return false unless @export.save
    Backburner.enqueue self.class, @export.id
    true
  end

  def export
    Tempfile.create('opti-export') do |f|
      CSV(f, col_sep: @export.separator) do |csv_out|
        csv_out << @export.source.headers.map(&:name) if @export.header
        @export.source.rows.each { |r| csv_out << r }
      end

      f.flush
      @export.sha256 = Digest::SHA256.file(f.path).hexdigest
      FileUtils.cp f.path, @export.path
    end

    @export.save
  end
end
