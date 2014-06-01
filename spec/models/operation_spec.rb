require 'spec_helper'

describe Operation do
  subject(:operation) { build :operation }

  it 'is valid' do
    expect(operation).to be_valid
  end
end
