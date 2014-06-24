require 'spec_helper'

feature 'Works status' do
  background do
    work.save
    visit works_path
  end

  context 'when work is queued' do
    let(:work) { build :work }

    it 'lists status as queued' do
      expect(page).to have_content 'Queued'
    end
  end

  context 'when work is beeing processed' do
    let(:work) { build :work, started_at: Time.now }

    it 'lists status as processing' do
      expect(page).to have_content 'Processing'
    end
  end

  context 'when work has been processed' do
    let(:work) { build :work, started_at: Time.now, processed_at: Time.now }

    it 'lists status as processed' do
      expect(page).to have_content 'Processed'
    end
  end

  context 'when work failed' do
    let(:work) { build :work, started_at: Time.now, failed_at: Time.now }

    it 'lists status as failed' do
      expect(page).to have_content 'Error'
    end
  end

  context 'when work was terminated' do
    let(:work) { build :work, started_at: Time.now, terminated_at: Time.now }

    it 'lists status as timeout' do
      expect(page).to have_content 'Timeout'
    end
  end
end
