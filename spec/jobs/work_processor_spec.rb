require 'spec_helper'

describe WorkProcessor do
  class DummyOperation
    attr_reader :input, :params, :output, :ignore_lines

    def initialize(input, params, output, ignore_lines: 0)
      @input        = input
      @params       = params
      @output       = output
      @ignore_lines = ignore_lines
    end

    def process!
    end

    def results_report
      {}
    end
  end

  let(:operations)    { { dummy: DummyOperation } }
  let(:operation)     { create :operation, name: 'Dummy', ref: 'dummy' }
  let(:work)          { create :work, operation: operation }
  let(:saver)         { double('source saver').as_null_object }

  subject :processor do
    described_class.new(work, source_saver: saver, operations: operations)
  end

  describe '#work' do
    it 'returns the assigned work' do
      expect(processor.work).to be work
    end
  end

  describe '#call' do
    it 'touches started_at' do
      processor.call
      expect(work.started_at).to be_within(1.second).of Time.now
    end

    it 'processes the operation' do
      expect_any_instance_of(DummyOperation).to receive :process!
      processor.call
    end

    context 'when operation succeeds' do
      it 'builds a new saver' do
        expect(saver)
          .to receive(:new).with(an_instance_of(Source), an_instance_of(File), false)
        processor.call
      end

      it 'calls the new saver' do
        saver_instance = double 'saver instance'
        allow(saver).to receive(:new) { saver_instance }
        expect(saver_instance).to receive :call
        processor.call
      end

      it 'touches processed_at' do
        processor.call
        expect(work.processed_at).to be_within(1.second).of Time.now
      end
    end

    context 'when operation fails' do
      before do
        allow_any_instance_of(DummyOperation)
          .to receive(:process!).and_raise RuntimeError
      end

      it 'does not hide the error' do
        expect { processor.call }.to raise_error RuntimeError
      end

      it 'does not touch processed_at' do
        expect { processor.call rescue RuntimeError }
          .not_to change { work.processed_at }
      end

      it 'touches failed_at' do
        processor.call rescue RuntimeError
        expect(work.failed_at).to be_within(1.second).of Time.now
      end
    end

    context 'when operation timeouts' do
      before do
        allow_any_instance_of(DummyOperation)
          .to receive(:process!).and_raise Backburner::Job::JobTimeout
      end

      it 'does not hide the error' do
        expect { processor.call }.to raise_error Backburner::Job::JobTimeout
      end

      it 'does not touch processed_at' do
        expect { processor.call rescue Backburner::Job::JobTimeout }
          .not_to change { work.processed_at }
      end

      it 'does not touch failed_at' do
        expect { processor.call rescue Backburner::Job::JobTimeout }
          .not_to change { work.failed_at }
      end

      it 'touches terminated_at' do
        processor.call rescue Backburner::Job::JobTimeout
        expect(work.terminated_at).to be_within(1.second).of Time.now
      end
    end
  end

  describe '#operation_to' do
    it 'builds a new operation' do
      expect(DummyOperation).to receive :new
      processor.operation_to StringIO.new
    end
  end

  describe '#operation_class' do
    it 'returns the operation class' do
      expect(processor.operation_class).to eq DummyOperation
    end
  end

  describe '#output_file' do
    let(:file)            { StringIO.new }
    let(:file_name)       { 'some_file' }
    subject(:output_file) { processor.output_file file, file_name }

    it 'defines original_filename as the file name' do
      expect(output_file.original_filename).to eq file_name
    end
  end
end
