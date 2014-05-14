require 'spec_helper'

feature 'Data files CRUD' do
  scenario 'lists data files' do
    FactoryGirl.create(:data_file, label: 'some file')
    FactoryGirl.create(:data_file, label: 'other file')

    visit data_files_path

    expect(page.body).to match /some file.+other file/m
  end

  scenario 'shows data file' do
    FactoryGirl.create(:data_file, label: 'some file')

    visit data_files_path
    click_link 'some file'

    expect(page.body).to include 'some file'
  end

  scenario 'creates data file' do
    visit data_files_path

    click_link 'Ajouter un fichier'
    fill_in 'Label', with: 'some file'
    click_button 'Enregistrer'

    expect(current_path).to eq data_files_path
    expect(page.body).to include 'some file'
  end

  scenario 'edits data file' do
    FactoryGirl.create(:data_file, label: 'some file')
    visit data_files_path

    click_link 'Modifier'
    fill_in 'Label', with: 'a new label'
    click_button 'Enregistrer'

    expect(current_path).to eq data_files_path
    expect(page.body).to include 'a new label'
  end

  scenario 'destroys data file' do
    FactoryGirl.create(:data_file, label: 'some file')
    visit data_files_path

    click_link 'Supprimer'

    expect(current_path).to eq data_files_path
    expect(page.body).to_not include 'some file'
  end
end
