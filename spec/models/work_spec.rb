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

  describe '#status' do
    context 'when work has been processed' do
      let(:work) { build :work, processed_at: Time.now }

      it 'returns :processed' do
        expect(work.status).to be :processed
      end
    end

    context 'when work failed' do
      let(:work) { build :work, failed_at: Time.now }

      it 'returns :error' do
        expect(work.status).to be :error
      end
    end

    context 'when work has terminated' do
      let(:work) { build :work, terminated_at: Time.now }

      it 'returns :timeout' do
        expect(work.status).to be :timeout
      end
    end
  end
end
