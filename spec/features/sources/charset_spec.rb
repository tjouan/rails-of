require 'spec_helper'

feature 'Sources file charset detection' do
  include AcceptanceHelpers

  background do
    sign_in
    create_source file: file_name
    visit sources_path
    click_link file_name
  end

  context 'when file is encoded as utf-8' do
    let(:file_name) { 'mydata.csv' }

    scenario 'detects utf-8 charset' do
      expect(page).to have_content 'utf-8'
    end
  end

  context 'when file is encoded as latin*' do
    let(:file_name) { 'mydata_latin1.csv' }

    scenario 'detects iso-8859-15 charset' do
      expect(page).to have_content 'iso-8859-15'
    end
  end
end
