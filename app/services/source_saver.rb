class SourceSaver
  HEADER_PLACEHOLDER    = 'Champ %d'.freeze
  CHARSET_CHECK_LENGTH  = (500 * (10 ** 3)).freeze
  CHARSETS              = %w[utf-8 iso-8859-15].freeze

  attr_reader :source, :file

  def initialize(source, file)
    @source = source
    @file   = file
  end

  def call
    save_file
    source.charset    = detect_charset
    source.rows_count = source.rows.count
    source.headers    = build_headers(detect_names: source.file_header)
    source.save
  end

  def save_file
    source.sha256 = Digest::SHA256.file(file.path).hexdigest
    FileUtils.cp file.path, source.path
    source.file_name = Pathname.new(file.original_filename).to_s
    source.mime_type = file.content_type
  end

  def detect_charset
    sample = file.read CHARSET_CHECK_LENGTH
    CHARSETS.detect do |e|
      sample.force_encoding(e).valid_encoding?
    end
  end

  def build_headers(detect_names: true)
    fd = File.new(file.path, encoding: source.charset)
    CSV.new(fd).shift.map.each_with_index do |e, i|
      Header.new(
        position: i,
        name: detect_names ? e : HEADER_PLACEHOLDER % [i + 1],
        type: :text
      )
    end
  end
end
