class WorkProcessor
  class << self
    def perform(work_id)
      new(Work.find(work_id)).call
    end
  end

  attr_reader :work

  def initialize(work)
    @work = work
  end

  def call
    work.touch :started_at

    Tempfile.create('opti-work') do |f|
      operation_to(f).process!
      f.rewind
      SourceSaver.new(
        Source.new(
          label: "#{work.source.label} enrichi par GeoScore",
          file: output_file(f, work.source.file_name)
        )
      ).call
    end

    work.touch :processed_at
  end

  def operation_to(output)
    @operation ||= GeoScore::Operation.new(
      work.source.to_file,
      params,
      output,
      ignore_lines: work.source.file_header ? 1 : 0
    )
  end

  def params
    work.parameters.map &:to_i
  end

  def output_file(file, file_name)
    file.define_singleton_method(:original_filename) { file_name }
    file.define_singleton_method(:content_type)      { 'text/csv' }
    file
  end
end
