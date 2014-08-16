require 'spec_helper'

feature 'Sources header' do
  include AcceptanceHelpers

  background do
    sign_in
  end

  context 'new' do
    scenario 'detects columns count' do
      create_source header: false
      expect(page.all('.source-headers-list select').size).to eq 3
    end

    scenario 'detects header names' do
      create_source
      click_icon 'Edit'
      expect(page.first('.source-headers-list input[type=text]').value)
        .to eq 'name'
    end

    scenario 'lists available data types' do
      create_source header: false
      expect(page).to have_select(
        'source[headers_attributes][0][type]',
        with_options: %w[Texte Entier]
      )
    end
  end

  context 'create' do
    scenario 'creates header' do
      create_source header: false
      click_button 'Enregistrer'
      click_link 'mydata'

      expect(page.all('.source-headers-list tbody td').map(&:text)).to eq [
        'Champ 1', 'Texte',
        'Champ 2', 'Texte',
        'Champ 3', 'Texte'
      ]
    end
  end

  context 'edit' do
    background do
      create_source
      click_icon 'Edit'
    end

    scenario 'edits a header' do
      fill_in 'source[headers_attributes][0][name]', with: 'other name'
      click_button 'Enregistrer'
      click_link 'mydata'

      expect(page.all('.source-headers-list tbody td').first.text)
        .to eq 'other name'
    end
  end
end
