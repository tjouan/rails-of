require 'spec_helper'

describe Work do
  subject(:work) { build :work }

  it 'is valid' do
    expect(work).to be_valid
  end

  it 'validates presence of the operation' do
    expect(work).to validate_presence_of :operation
  end

  it 'validates presence of the source' do
    expect(work).to validate_presence_of :source
  end

  it 'validates parameters existence' do
    expect(work).not_to allow_value(nil).for :parameters
  end
end
