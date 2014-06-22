require 'spec_helper'

describe Operation do
  subject(:operation) { build :operation }

  it 'is valid' do
    expect(operation).to be_valid
  end

  context 'without name' do
    before { operation.name = nil }

    it 'is not valid' do
      expect(operation).not_to be_valid
    end
  end

  context 'without ref' do
    before { operation.ref = nil }

    it 'is not valid' do
      expect(operation).not_to be_valid
    end
  end
end
