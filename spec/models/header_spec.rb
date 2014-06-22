require 'spec_helper'

describe Header do
  subject(:header) { build :header }

  it 'is valid' do
    expect(header).to be_valid
  end

  context 'without position' do
    before { header.position = nil }

    it 'is not valid' do
      expect(header).not_to be_valid
    end
  end

  context 'without name' do
    before { header.name = nil }

    it 'is not valid' do
      expect(header).not_to be_valid
    end
  end

  context 'without type' do
    before { header.type = nil }

    it 'is not valid' do
      expect(header).not_to be_valid
    end
  end

  describe '#type=' do
    it 'raises ArgumentError when given type is invalid' do
      expect { header.type = :non_existent_type }.to raise_error ArgumentError
    end
  end

  describe '#type_description' do
    it 'returns the type description' do
      expect(header.type_description).to eq 'texte'
    end
  end
end
