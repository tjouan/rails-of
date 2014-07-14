class WorkProcessor
  OPERATIONS = {
    geoscore:   GeoScore::Operation,
    opticible:  Operations::Opticible
  }.freeze

  class << self
    def perform(work_id)
      new(Work.find(work_id)).call
    end
  end

  attr_reader :work, :operations, :source_saver

  def initialize(work, operations: OPERATIONS, source_saver: SourceSaver)
    @work         = work
    @operations   = operations
    @source_saver = source_saver
  end

  def call
    work.touch :started_at

    Tempfile.create('opti-work') do |f|
      operation_to(f).process!
      f.rewind
      source_saver.new(
        Source.new(
          label: "#{work.source.label} enrichi par #{work.operation.name}",
          file: output_file(f, work.source.file_name)
        )
      ).call
    end
  rescue Backburner::Job::JobTimeout
    work.touch :terminated_at
    raise
  rescue => ex
    work.touch :failed_at
    raise
  else
    work.touch :processed_at
  end

  def operation_to(output)
    operation = operation_class.new(
      work.source.to_file,
      work.parameters,
      output,
      ignore_lines: work.source.file_header ? 1 : 0
    )
    operation.work = work if operation.respond_to? :work=
    operation
  end

  def operation_class
    operations[work.operation.ref.to_sym]
  end

  def output_file(file, file_name)
    file.define_singleton_method(:original_filename) { file_name }
    file.define_singleton_method(:content_type)      { 'text/csv' }
    file
  end
end
