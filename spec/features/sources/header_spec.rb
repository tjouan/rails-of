require 'spec_helper'

feature 'Sources header' do
  def create_file(header: false)
    visit new_source_path
    if header
      check 'en-tête'
    else
      uncheck 'en-tête'
    end
    attach_file 'source_file', File.join(fixture_path, '3col_header.csv')
    click_button 'Enregistrer'
  end

  before do
    create_file
  end

  context 'new' do
    scenario 'detects columns count' do
      expect(page.all('main form .source_header_key').size).to eq 3
    end

    scenario 'detects header' do
      create_file(header: true)
      expect(page.first('main form input[type=text]').value).to eq 'name'
    end

    scenario 'list available data types' do
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

      expect(page.all('main table tbody td').map(&:text)).to eq [
        'Champ 1', 'Texte',
        'Champ 2', 'Texte',
        'Champ 3', 'Texte'
      ]
    end
  end
end
