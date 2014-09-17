class SourceNormalizer
  XLSX_MIMES = %w[
    application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
  ].freeze

  attr_reader :input_path, :format, :charset, :first_row, :rows_added

  def initialize(input_path, format, charset, has_header)
    @input_path = input_path
    @format     = format
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
      rows.each do |r|
        if !first_row
          @first_row = r
          next if header?
        end
        csv_out << r
        @rows_added += 1
      end
    end
    output.path
  rescue CSV::MalformedCSVError
    fail OptiFront::UnknownSourceError
  ensure
    output.close
  end

  def rows
    if xlsx?
      xlsx_enum
    else
      CSV.foreach(input_path, encoding: '%s:utf-8' % charset)
    end
  end

  def xlsx?
    XLSX_MIMES.any? { |e| format.downcase.include? e }
  end

  def xlsx_enum
    require 'creek'

    sheet = Creek::Book.new(input_path, check_file_extension: false).sheets.first
    Enumerator.new do |y|
      begin
        sheet.rows.each { |e| y << e.values }
      rescue ArgumentError
        fail OptiFront::UnknownSourceError
      end
    end
  end
end
