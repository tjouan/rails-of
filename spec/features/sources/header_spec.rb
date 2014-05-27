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
      expect(page).to have_select('source_header_type', options: Source.types)
    end
  end
end
