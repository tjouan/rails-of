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

  it 'accepts nested attributes for headers' do
    expect(source).to accept_nested_attributes_for :headers
  end

  context 'before create' do
    it 'assigns a default label as the attached file name' do
      source.label = nil
      source.save
      expect(source.label).to eq 'mydata.csv'
    end
  end

  describe '#path' do
    it 'returns a path to the attached file' do
      expect(source.path)
        .to eq "#{Rails.configuration.sources_path}/#{source.sha256}"
    end
  end

  describe '#to_file' do
    context 'when a file is assigned' do
      let(:file)        { double 'file' }
      subject(:source)  { described_class.new(file: file) }

      it 'returns the assigned file' do
        expect(source.to_file).to be file
      end
    end

    context 'when a file is attached (not assigned)' do
      before { source.file = nil }

      it 'builds a File' do
        expect(File).to receive(:new).with(source.path, encoding: source.charset)
        source.to_file
      end

      it 'returns the file' do
        file = double 'file'
        allow(File).to receive(:new) { file }
        expect(source.to_file).to be file
      end
    end

    context 'when no file is available' do
      subject(:source) { described_class.new }

      it 'returns nil' do
        expect(source.to_file).to be nil
      end
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

  describe '#first_row' do
    it 'detects keys' do
      expect(source.first_row).to eq ['name', 'score', 'active']
    end
  end

  describe '#detect_headers!' do
    it 'detects columns count' do
      source.detect_headers!
      expect(source.headers.size).to eq 3
    end

    it 'assigns columns position' do
      source.detect_headers!
      expect(source.headers.map &:position).to eq [0, 1, 2]
    end

    context 'not detecting header names' do
      it 'builds placeholder headers' do
        source.detect_headers!
        expect(source.headers.last.name).to eq 'Champ 3'
      end
    end

    context 'detecting header names' do
      before { source.file_header = true }

      it 'builds headers with names read from file' do
        source.detect_headers!
        expect(source.headers.map &:name).to eq %w[name score active]
      end
    end
  end

  describe '#set_charset' do
    before { source.set_charset }

    it 'assigns the charset' do
      expect(source.charset).to eq 'utf-8'
    end

    context 'when attached file is coded in latin1' do
      subject(:source) { build :source_latin1 }

      it 'assigns iso-8859-15 charset' do
        expect(source.charset).to eq 'iso-8859-15'
      end
    end

    context 'when no file is attached' do
      subject(:source) { described_class.new }

      it 'does not change the charset' do
        expect { source.set_charset }.not_to change { source.charset }
      end
    end
  end
end
