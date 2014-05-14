require 'spec_helper'

feature 'Data files header' do
  scenario 'updates a data file without header' do
    visit new_data_file_path

    uncheck 'en-tête'
    click_button 'Enregistrer'
    visit data_file_path(DataFile.last)

    expect(page.body).to match /en-tête.+non/im
  end

  scenario 'updates a data file with header' do
    visit new_data_file_path

    check 'en-tête'
    click_button 'Enregistrer'
    visit data_file_path(DataFile.last)

    expect(page.body).to match /en-tête.+oui/im
  end
end
