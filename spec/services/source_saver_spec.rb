require 'spec_helper'

describe SourceSaver do
  let(:file)      { fixture_file_upload 'mydata.csv', 'text/csv' }
  let(:user)      { create :user }
  let(:source)    { user.sources.new }
  subject(:saver) { described_class.new(source, file) }

  describe '#call' do
    it 'saves the file' do
      saver.call
      expect { source.to_file }.not_to raise_error
    end

    it 'updates source rows count' do
      saver.call
      expect(source.rows_count).to eq 4
    end

    it 'detects headers' do
      expect { saver.call }.to change(source.headers, :count).by 3
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
    it 'detects columns count' do
      expect(saver.build_headers.size).to eq 3
    end

    it 'assigns columns position' do
      expect(saver.build_headers.map &:position).to eq [0, 1, 2]
    end

    context 'not detecting header names' do
      it 'builds placeholder headers' do
        expect(saver.build_headers(detect_names: false).last.name)
          .to eq 'Champ 3'
      end
    end

    context 'detecting header names' do
      it 'builds headers with names read from file' do
        expect(saver.build_headers.map &:name).to eq %w[name score active]
      end
    end
  end
end
