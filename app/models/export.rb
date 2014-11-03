class Export < ActiveRecord::Base
  CHARSETS    = %w[utf-8 iso-8859-15 iso-8859-1].freeze
  SEPARATORS  = {
    ','   =>  'comma',
    ';'   =>  'semicolon',
    "\t"  =>  'tabulation'
  }.freeze

  belongs_to :source

  after_initialize :set_defaults, if: :new_record?

  validates :source,    presence: true
  validates :charset,   inclusion: CHARSETS
  validates :header,    presence: true
  validates :separator, inclusion: SEPARATORS.keys
  validates :file_name, presence: true

  default_scope { order('created_at DESC') }


  def ready?
    !!sha256
  end

  def path
    File.join(Rails.configuration.sources_path, sha256)
  end

  def charsets
    CHARSETS
  end

  def separators
    SEPARATORS
  end

  def separator_description
    separator.inspect.gsub '"', ''
  end

  def set_defaults
    self.charset ||= 'utf-8'

    self.header = true if header.nil?

    self.separator ||= ','

    unless file_name
      self.file_name = source.file_name
      self.file_name += '.csv' unless self.file_name =~ /\.csv\z/
    end
  end
end
