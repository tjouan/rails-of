class WorkSubmitter
  require 'tempfile'

  attr_reader :work

  def initialize(work)
    @work = work
  end

  def call
    return false unless work.save

    Tempfile.create('opti-work') do |f|
      operation_to(f).process!
      f.rewind
      Source.create(
        label: "#{work.source.label} enrichi par GeoScore",
        file: output_file(f, work.source.file_name)
      )
    end

    true
  end

  def operation_to(output)
    @operation ||= GeoScore::Operation.new(
      File.new(work.source.path),
      params,
      output
    )
  end

  def params
    [0, 1]
  end

  def output_file(file, file_name)
    file.define_singleton_method(:original_filename) { file_name }
    file.define_singleton_method(:content_type)      { 'text/csv' }
    file
  end
end
