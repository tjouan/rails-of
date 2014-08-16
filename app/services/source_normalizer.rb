class SourceNormalizer
  attr_reader :input_path, :charset, :first_row, :rows_added

  def initialize(input_path, charset, has_header)
    @input_path = input_path
    @charset    = charset
    @has_header = has_header

    @first_row  = nil
    @rows_added = 0
  end

  def header?
    @has_header
  end

  def normalize!
    output = Tempfile.new('opti-normalize')
    CSV(output) do |csv_out|
      CSV.foreach(input_path, encoding: '%s:utf-8' % charset) do |r|
        if !first_row
          @first_row = r
          next if header?
        end
        csv_out << r
        @rows_added += 1
      end
    end
    output.path
  ensure
    output.close
  end
end
