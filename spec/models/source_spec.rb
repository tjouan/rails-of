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

  describe '#file?' do
    context 'without a file' do
      it 'returns false' do
        expect(source.file?).to be false
      end
    end

    context 'with a file' do
      subject(:source) { FactoryGirl.build(:source_with_file) }

      it 'returns true' do
        expect(source.file?).to be true
      end
    end
  end

  describe '#editable_header' do
    subject(:source) { FactoryGirl.build(:source_with_file) }

    context 'file without header' do
      it 'returns the placeholder' do
        expect(source.editable_header).to eq({
          'Champ 1' => nil,
          'Champ 2' => nil,
          'Champ 3' => nil
        })
      end
    end

    context 'file with header' do
      let(:header) { { some_header_key: nil } }

      before do
        source.header = {}
        allow(source).to receive(:file_header) { header }
      end

      it 'returns the file header' do
        expect(source.editable_header).to eq header
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
