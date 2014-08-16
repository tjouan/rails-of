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

    it 'returns the file' do
      file = double 'file'
      allow(File).to receive(:new) { file }
      expect(source.to_file).to be file
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
  end

  describe '#line_sample' do
    it 'returns the first row of #rows' do
      expect(source.line_sample).to eq source.rows.first
    end
  end
end
