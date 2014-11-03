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
    Tempfile.create('opti-export', io_options) do |f|
      CSV(f, csv_options) do |csv_out|
        csv_out << @export.source.headers.map(&:name) if @export.header
        @export.source.rows.each { |r| csv_out << r }
      end

      f.flush
      @export.sha256 = Digest::SHA256.file(f.path).hexdigest
      FileUtils.cp f.path, @export.path
    end

    @export.save
  end


  private

  def io_options
    {
      external_encoding:  @export.charset,
      undef:              :replace
    }
  end

  def csv_options
    {
      col_sep: @export.separator
    }
  end
end
