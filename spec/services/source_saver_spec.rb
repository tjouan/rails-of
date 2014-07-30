require 'spec_helper'

describe SourceSaver do
  let(:file)      { fixture_file_upload 'mydata.csv', 'text/csv' }
  let(:source)    { Source.new }
  subject(:saver) { SourceSaver.new(source, file) }

  describe '#call' do
    it 'saves the file' do
      saver.call
      expect { source.to_file }.not_to raise_error
    end

    it 'updates source charset' do
      expect { saver.call }.to change(source, :charset)
    end

    it 'updates source rows count' do
      saver.call
      expect(source.rows_count).to eq 4
    end

    it 'saves the source' do
      expect { saver.call }.to change(Source, :count).by 1
    end
  end

  describe '#save_file' do
    it 'copies the file' do
      saver.save_file
      expect(File.read(source.path)).to eq file.read
    end

    it 'updates the source SHA256 digest' do
      saver.save_file
      expect(source.sha256).to eq Digest::SHA256.file(file.path).hexdigest
    end

    it 'updates the source file name' do
      saver.save_file
      expect(source.file_name).to eq 'mydata.csv'
    end

    it 'updates the source mime type' do
      saver.save_file
      expect(source.mime_type).to eq 'text/csv'
    end
  end
end
