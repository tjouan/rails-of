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
    subject(:source) { described_class.new attributes_for(:source) }

    it 'builds a File with #charset as the encoding' do
      expect(File).to receive(:new).with(source.path, encoding: source.charset)
      source.to_file
    end

    it 'returns the file' do
      file = double 'file'
      allow(File).to receive(:new) { file }
      expect(source.to_file).to be file
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

  describe '#rows' do
    it 'enumerates all data lines' do
      expect(source.rows.each.to_a).to eq [
        %w[foo 42 1],
        %w[bar 13 1],
        %w[baz 32 0]
      ]
    end

    context 'without file header' do
      before { source.file_header = false }

      it 'starts at the very first line' do
        expect(source.rows.shift).to eq %w[name score active]
      end
    end
  end

  describe '#first_row' do
    it 'returns the very first row even with truthy file_header' do
      source.file_header = true
      expect(source.first_row).to eq %w[name score active]
    end
  end

  describe '#line_sample' do
    it 'returns the first row of #rows' do
      expect(source.line_sample).to eq source.rows.first
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
      before { source.file_header = false }

      it 'builds placeholder headers' do
        source.detect_headers!
        expect(source.headers.last.name).to eq 'Champ 3'
      end
    end

    context 'detecting header names' do
      it 'builds headers with names read from file' do
        source.detect_headers!
        expect(source.headers.map &:name).to eq %w[name score active]
      end
    end
  end

  describe '#set_charset' do
    before do
      source.charset = nil
      source.set_charset
    end

    it 'assigns the charset' do
      expect(source.charset).to eq 'utf-8'
    end

    context 'when attached file is coded in latin1' do
      before do
        file = File.new(File.join(fixture_path, 'mydata_latin1.csv'))
        allow(source).to receive(:to_file) { file }
        source.set_charset
      end

      it 'assigns iso-8859-15 charset' do
        expect(source.charset).to eq 'iso-8859-15'
      end
    end
  end
end
