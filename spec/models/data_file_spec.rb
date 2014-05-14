require 'spec_helper'

describe DataFile do
  subject(:data_file) { FactoryGirl.build(:data_file) }

  it { is_expected.to be_valid }

  describe 'path' do
    subject(:data_file) { FactoryGirl.build(:data_file_with_file) }

    it 'returns the attached file path' do
      expect(data_file.path)
        .to eq "#{Rails.configuration.data_files_path}/#{data_file.sha256}"
    end
  end

  describe '#file=' do
    let(:file)          { FactoryGirl.attributes_for(:data_file_with_file)[:file] }
    subject(:data_file) { FactoryGirl.build(:data_file_with_file) }

    it 'copies the file' do
      expect(File.read(data_file.path)).to eq file.read
    end

    it 'updates the SHA256 digest' do
      expect(data_file.sha256).to eq Digest::SHA256.file(file.path).hexdigest
    end

    it 'updates the file name' do
      expect(data_file.file_name).to eq 'sample_0.csv'
    end

    it 'updates the mime type' do
      expect(data_file.mime_type).to eq 'text/csv'
    end
  end

  describe '#file?' do
    context 'without a file' do
      it 'returns false' do
        expect(data_file.file?).to be false
      end
    end

    context 'with a file' do
      subject(:data_file) { FactoryGirl.build(:data_file_with_file) }

      it 'returns true' do
        expect(data_file.file?).to be true
      end
    end
  end

  describe '#editable_header' do
    subject(:data_file) { FactoryGirl.build(:data_file_with_file) }

    context 'file without header' do
      it 'returns the placeholder' do
        expect(data_file.editable_header).to eq({
          'Champ 1' => nil,
          'Champ 2' => nil,
          'Champ 3' => nil
        })
      end
    end

    context 'file with header' do
      let(:header) { { some_header_key: nil } }

      before do
        data_file.header = {}
        allow(data_file).to receive(:file_header) { header }
      end

      it 'returns the file header' do
        expect(data_file.editable_header).to eq header
      end
    end
  end

  describe '#file_header' do
    subject(:data_file) { FactoryGirl.build(:data_file_with_file) }

    it 'detects keys' do
      expect(data_file.file_header).to eq ['name', 'score', 'active']
    end
  end
end
