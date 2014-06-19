require 'spec_helper'

feature 'Sources file charset detection' do
  include AcceptanceHelpers

  background do
    create_source file: file_name
    visit sources_path
    click_link file_name
  end

  context 'when file is encoded as utf-8' do
    let(:file_name) { '3col_header.csv' }

    scenario 'detects utf-8 charset' do
      expect(page).to have_content 'UTF-8'
    end
  end

  context 'when file is encoded as latin*' do
    let(:file_name) { '3col_header_body_latin1.csv' }

    scenario 'detects iso-8859-15 charset' do
      expect(page).to have_content 'ISO-8859-15'
    end
  end
end
