require 'spec_helper'

describe Header do
  subject(:header) { FactoryGirl.build(:header) }

  it 'is valid' do
    expect(header).to be_valid
  end

  describe '#type_description' do
    it 'returns the type description' do
      expect(header.type_description).to eq 'texte'
    end
  end
end
