require 'spec_helper'

feature 'Sources file' do
  include AcceptanceHelpers

  let(:file_name) { '3col_header.csv' }

  background { create_source file: file_name }

  context 'creation' do
    scenario 'creates source with attached file' do
      visit sources_path
      click_link file_name

      expect(page).to have_content '3col_header.csv'
      expect(page).to have_content 'text/csv'
    end

    scenario 'redirects to headers/new' do
      expect(current_path).to eq new_source_headers_path(Source.last)
    end
  end

  context 'download' do
    let(:file) { File.new(File.join(fixture_path, file_name)) }

    background do
      visit sources_path
      click_link 'Télécharger'
    end

    scenario 'gets the attached file' do
      expect(page.body).to eq file.read
    end

    scenario 'sets the source content-type' do
      expect(response_headers['Content-Type']).to eq 'text/csv'
    end
  end
end
