require 'spec_helper'

feature 'Data files header' do
  def create_file(header: false)
    visit new_data_file_path
    if header
      check 'en-tête'
    else
      uncheck 'en-tête'
    end
    attach_file 'data_file_file', File.join(fixture_path, 'sample_0.csv')
    click_button 'Enregistrer'
  end

  before do
    create_file
  end

  scenario 'updates a data file without header' do
    visit data_file_path(DataFile.last)

    expect(page.body).to match /en-tête.+non/im
  end

  scenario 'updates a data file with header' do
    create_file(header: true)
    visit data_file_path(DataFile.last)

    expect(page.body).to match /en-tête.+oui/im
  end

  context 'edit' do
    scenario 'detects columns count' do
      expect(page.all('main form .data_file_header_key').size).to eq 3
    end

    scenario 'detects header' do
      create_file(header: true)
      expect(page.first('main form input[type=text]').value).to eq 'name'
    end

    scenario 'list available data types' do
      expect(page).to have_select('data_file_header_type', options: [
        'chaîne de caractères',
        'entier'
      ])
    end
  end
end
