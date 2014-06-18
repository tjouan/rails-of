require 'spec_helper'

feature 'Sources file' do
  let(:file_path) { File.join(fixture_path, '3col_header.csv') }

  before do
    visit new_source_path
    fill_in 'Label', with: 'some file'
    attach_file 'source_file', file_path
    click_button 'Enregistrer'
  end

  context 'creation' do
    scenario 'creates source with attached file' do
      visit sources_path
      click_link 'some file'

      expect(page.body).to include '3col_header.csv'
      expect(page.body).to include 'text/csv'
    end

    scenario 'redirects to header new' do
      expect(current_path).to eq new_source_headers_path(Source.last)
    end

    context 'when file charset is invalid' do
      let(:file_path) { File.join(fixture_path, '3col_header_body_latin1.csv') }

      scenario 'shows error message' do
        expect(page.body)
          .to match /erreur.+détect.+jeu.+caractères/mi
      end
    end
  end

  context 'download' do
    before do
      visit sources_path
      click_link 'Télécharger'
    end

    scenario 'gets the attached file' do
      expect(page.body).to eq File.new(file_path).read
    end

    scenario 'sets the source content-type' do
      expect(response_headers['Content-Type']).to eq 'text/csv'
    end
  end
end
