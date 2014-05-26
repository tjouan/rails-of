require 'spec_helper'

describe Source do
  subject(:source) { FactoryGirl.build(:source) }

  it 'is valid' do
    expect(source).to be_valid
  end

  describe 'path' do
    subject(:source) { FactoryGirl.build(:source_with_file) }

    it 'returns the attached file path' do
      expect(source.path)
        .to eq "#{Rails.configuration.sources_path}/#{source.sha256}"
    end
  end

  describe '#file=' do
    let(:file)          { FactoryGirl.attributes_for(:source_with_file)[:file] }
    subject(:source) { FactoryGirl.build(:source_with_file) }

    it 'copies the file' do
      expect(File.read(source.path)).to eq file.read
    end

    it 'updates the SHA256 digest' do
      expect(source.sha256).to eq Digest::SHA256.file(file.path).hexdigest
    end

    it 'updates the file name' do
      expect(source.file_name).to eq '3col_header.csv'
    end

    it 'updates the mime type' do
      expect(source.mime_type).to eq 'text/csv'
    end
  end

  describe '#header?' do
    context 'without header' do
      it 'returns false' do
        expect(source.header?).to be false
      end
    end

    context 'with at least a header' do
      before { source.headers = [Header.new] }

      it 'returns true' do
        expect(source.header?).to be true
      end
    end
  end

  describe '#detect_headers!' do
    subject(:source) { FactoryGirl.build(:source_with_file) }

    context 'not detecting from file' do
      it 'builds placeholder headers' do
        source.detect_headers!
        expect(source.headers.size).to eq 3
        expect(source.headers.last.name).to eq 'Champ 3'
      end
    end

    context 'detecting from file' do
      it 'builds headers from file content' do
        source.detect_headers! true
        expect(source.headers.size).to eq 3
        expect(source.headers.last.name).to eq 'active'
      end
    end
  end

  describe '#file_header' do
    subject(:source) { FactoryGirl.build(:source_with_file) }

    it 'detects keys' do
      expect(source.file_header).to eq ['name', 'score', 'active']
    end
  end
end
