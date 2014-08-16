class SourceSaver
  HEADER_PLACEHOLDER    = 'Champ %d'.freeze
  CHARSET_CHECK_LENGTH  = (500 * (10 ** 3)).freeze
  CHARSETS              = %w[utf-8 iso-8859-15].freeze

  attr_reader :source, :file, :file_header

  def initialize(source, file, file_header, save: true)
    @source       = source
    @file         = file
    @file_header  = file_header
    @save         = save
  end

  def save?
    @save
  end

  def call
    save_file normalizer.normalize!
    source.file_name  = Pathname.new(file.original_filename).to_s
    source.rows_count = normalizer.rows_added
    source.headers    = build_headers(
      normalizer.first_row,
      detect_names: file_header
    )
    source.save if save?
  end

  def normalizer
    @normalizer ||= SourceNormalizer.new(
      file.path, detect_charset, file_header
    )
  end

  def save_file(file_path)
    source.sha256 = Digest::SHA256.file(file_path).hexdigest
    FileUtils.mv file_path, source.path
  end

  def detect_charset
    @detected_charset ||= begin
      sample = File.read(file.path, CHARSET_CHECK_LENGTH)
      CHARSETS.detect do |e|
        sample.force_encoding(e).valid_encoding?
      end
    end
  end

  def build_headers(row, detect_names: true)
    row.map.each_with_index do |e, i|
      Header.new(
        position: i,
        name: detect_names ? e : HEADER_PLACEHOLDER % [i + 1],
        type: :text
      )
    end
  end
end
