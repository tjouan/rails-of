require 'spec_helper'

describe DataFile do
  subject(:data_file) { FactoryGirl.build(:data_file) }

  it { is_expected.to be_valid }

  describe 'path' do
    subject(:data_file) { FactoryGirl.create(:data_file) }

    it 'returns the attached file path' do
      expect(data_file.path)
        .to eq "#{Rails.configuration.data_files_path}/#{data_file.id}"
    end
  end

  describe '#file=' do
    let(:file)          { fixture_file_upload '/sample_0.csv', 'text/csv' }
    subject(:data_file) { FactoryGirl.create(:data_file) }

    before do
      data_file.file = file
    end

    it 'copies the file' do
      expect(File.read(data_file.path)).to eq file.read
    end

    it 'updates the file name' do
      expect(data_file.file_name).to eq 'sample_0.csv'
    end

    it 'updates the mime type' do
      expect(data_file.mime_type).to eq 'text/csv'
    end
  end
end
