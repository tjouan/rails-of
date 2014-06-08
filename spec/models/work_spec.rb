require 'spec_helper'

describe Work do
  subject(:work) { build :work }

  it 'is valid' do
    expect(work).to be_valid
  end

  it 'validates parameters existence' do
    expect(work).not_to allow_value(nil).for :parameters
  end
end
