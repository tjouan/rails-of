require 'spec_helper'

describe SourceSaver do
  let(:file)      { fixture_file_upload 'mydata.csv', 'text/csv' }
  let(:source)    { Source.new }
  subject(:saver) { described_class.new(source, file, true, save: false) }

  describe '#call' do
    it 'saves the file' do
      saver.call
      expect { source.to_file }.not_to raise_error
    end

    it 'updates the source file name' do
      saver.call
      expect(source.file_name).to eq 'mydata.csv'
    end

    it 'updates source rows count' do
      saver.call
      expect(source.rows_count).to eq 3
    end

    it 'detects headers' do
      saver.call
      expect(source.headers.size).to eq 3
    end

    it 'saves the source' do
      saver = described_class.new(source, file, true)
      expect(source).to receive(:save)
      saver.call
    end
  end

  describe '#save_file' do
    it 'moves the given file' do
      saver.save_file(file.path)
      expect(File.read(source.path)).to eq file.read
    end

    it 'updates the source SHA256 digest' do
      digest = Digest::SHA256.file(file.path).hexdigest
      saver.save_file(file.path)
      expect(source.sha256).to eq digest
    end
  end

  describe '#detect_charset' do
    it 'detect the charset' do
      expect(saver.detect_charset).to eq 'utf-8'
    end

    context 'when attached file is coded in latin1' do
      let(:file) { fixture_file_upload 'mydata_latin1.csv', 'text/csv' }

      it 'detects iso-8859-15 charset' do
        expect(saver.detect_charset).to eq 'iso-8859-15'
      end
    end
  end

  describe '#build_headers!' do
    let(:row) { %w[name score active] }

    it 'detects columns count' do
      expect(saver.build_headers(row).size).to eq 3
    end

    it 'assigns columns position' do
      expect(saver.build_headers(row).map &:position).to eq [0, 1, 2]
    end

    context 'not detecting header names' do
      it 'builds placeholder headers' do
        expect(saver.build_headers(row, detect_names: false).last.name)
          .to eq 'Champ 3'
      end
    end

    context 'detecting header names' do
      it 'builds headers with names read from file' do
        expect(saver.build_headers(row).map &:name).to eq %w[name score active]
      end
    end
  end
end
