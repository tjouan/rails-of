require 'spec_helper'

feature 'Sources header' do
  include AcceptanceHelpers

  background { create_source }

  context 'new' do
    scenario 'detects columns count' do
      expect(page.all('main form .source_header_key').size).to eq 3
    end

    scenario 'detects header' do
      create_source header: true
      expect(page.first('main form input[type=text]').value).to eq 'name'
    end

    scenario 'lists available data types' do
      expect(page).to have_select(
        'source[headers_attributes][0][type]',
        with_options: %w[Texte Entier]
      )
    end
  end

  context 'create' do
    scenario 'creates header' do
      click_button 'Enregistrer'
      visit source_path(Source.last)

      expect(page.all('.source_header tbody td').map(&:text)).to eq [
        'Champ 1', 'Texte',
        'Champ 2', 'Texte',
        'Champ 3', 'Texte'
      ]
    end
  end

  context 'edit' do
    background do
      click_button 'Enregistrer'
      visit sources_path
    end

    scenario 'edits a header' do
      click_link 'Modifier'
      fill_in 'source[headers_attributes][0][name]', with: 'other name'
      click_button 'Enregistrer'
      visit source_path Source.last

      expect(page.all('.source_header tbody td').first.text).to eq 'other name'
    end
  end
end
