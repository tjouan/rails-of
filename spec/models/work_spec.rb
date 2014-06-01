require 'spec_helper'

describe Work do
  subject(:work) { build :work }

  it 'is valid' do
    expect(work).to be_valid
  end
end
