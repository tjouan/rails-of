require 'spec_helper'

describe SourceSaver do
  let(:file)      { fixture_file_upload 'mydata.csv', 'text/csv' }
  let(:source)    { build :source }
  subject(:saver) { SourceSaver.new(source) }

  before { source.file = file }

  describe '#save_file!' do
    it 'copies the file' do
      saver.save_file!
      expect(File.read(source.path)).to eq file.read
    end

    it 'updates the source SHA256 digest' do
      saver.save_file!
      expect(source.sha256).to eq Digest::SHA256.file(file.path).hexdigest
    end

    it 'updates the source file name' do
      saver.save_file!
      expect(source.file_name).to eq 'mydata.csv'
    end

    it 'updates the source mime type' do
      saver.save_file!
      expect(source.mime_type).to eq 'text/csv'
    end

    it 'returns true' do
      expect(saver.save_file!).to be true
    end

    context 'when source has no file' do
      before { source.file = nil }

      it 'returns false' do
        expect(saver.save_file!).to be false
      end
    end
  end
end
