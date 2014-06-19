require 'spec_helper'

describe Source do
  subject(:source) { build :source }

  it 'is valid' do
    expect(source).to be_valid
  end

  context 'without SHA256 sum' do
    before { source.sha256 = nil }

    it 'is not valid' do
      expect(source).not_to be_valid
    end
  end

  context 'when file charset can not be detected' do
    subject(:source) { build :source_latin1 }

    it 'is not valid' do
      expect(source).not_to be_valid
    end

    it 'registers an error message on validation' do
      source.valid?
      expect(source.errors[:charset].first)
        .to match /impossible.+détect.+jeu.+caractères/
    end
  end

  it 'accepts nested attributes for headers' do
    expect(source).to accept_nested_attributes_for :headers
  end

  it 'assigns a default label as the attached file name' do
    source.label = nil
    source.save
    expect(source.label).to eq '3col_header.csv'
  end

  describe '#path' do
    it 'returns a path to the attached file' do
      expect(source.path)
        .to eq "#{Rails.configuration.sources_path}/#{source.sha256}"
    end
  end

  describe '#to_file' do
    it 'returns a readable IO' do
      expect(source.to_file.read).to match /\Aname,score,active\nfoo/
    end
  end

  describe '#to_csv' do
    it 'returns a readable CSV' do
      expect(source.to_csv.shift.first).to eq 'name'
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

  describe '#file_header' do
    it 'detects keys' do
      expect(source.file_header).to eq ['name', 'score', 'active']
    end
  end

  describe '#detect_headers!' do
    it 'detect columns count' do
      source.detect_headers!
      expect(source.headers.size).to eq 3
    end

    context 'not detecting header names' do
      it 'builds placeholder headers' do
        source.detect_headers!
        expect(source.headers.last.name).to eq 'Champ 3'
      end
    end

    context 'detecting header names' do
      it 'builds headers with names read from file' do
        source.detect_headers! names: true
        expect(source.headers.last.name).to eq 'active'
      end
    end
  end
end
