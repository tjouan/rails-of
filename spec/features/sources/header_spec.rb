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

  scenario 'updates a source without header' do
    visit source_path(Source.last)

    expect(page.body).to match /en-tête.+non/im
  end

  scenario 'updates a source with header' do
    create_file(header: true)
    visit source_path(Source.last)

    expect(page.body).to match /en-tête.+oui/im
  end

  context 'edit' do
    scenario 'detects columns count' do
      expect(page.all('main form .source_header_key').size).to eq 3
    end

    scenario 'detects header' do
      create_file(header: true)
      expect(page.first('main form input[type=text]').value).to eq 'name'
    end

    scenario 'list available data types' do
      expect(page).to have_select('source_header_type', options: [
        'chaîne de caractères',
        'entier'
      ])
    end
  end
end
