require 'spec_helper'

feature 'Sources file' do
  include AcceptanceHelpers

  let(:file_name) { 'mydata.csv' }

  context 'creation' do
    scenario 'creates source with attached file' do
      create_source

      visit sources_path
      click_link file_name

      expect(page).to have_content file_name
      expect(page).to have_content 'text/csv'
    end

    scenario 'redirects to headers/new' do
      create_source

      expect(current_path).to eq edit_source_headers_path(Source.last)
    end

    scenario 'stores whether source include a file header' do
      create_source header: true

      visit source_path Source.last

      expect(page).to have_content /en-tête.+oui/mi
    end
  end
end
