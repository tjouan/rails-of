require 'spec_helper'

feature 'Sources CRUD' do
  scenario 'lists sources' do
    FactoryGirl.create(:source, label: 'some file')
    FactoryGirl.create(:source, label: 'other file')

    visit sources_path

    expect(page.body).to match /some file.+other file/m
  end

  scenario 'shows source' do
    FactoryGirl.create(:source, label: 'some file')

    visit sources_path
    click_link 'some file'

    expect(page.body).to include 'some file'
  end

  scenario 'creates source' do
    visit sources_path

    click_link 'Ajouter un fichier'
    fill_in 'Label', with: 'some file'
    attach_file 'source_file', File.join(fixture_path, '3col_header.csv').to_s
    click_button 'Enregistrer'

    expect(current_path).not_to eq new_source_path
    expect(page.body).to include 'some file'
  end

  scenario 'edits source' do
    FactoryGirl.create(:source, label: 'some file')
    visit sources_path

    click_link 'Modifier'
    fill_in 'Label', with: 'a new label'
    click_button 'Enregistrer'

    expect(current_path).to eq sources_path
    expect(page.body).to include 'a new label'
  end

  scenario 'destroys source' do
    FactoryGirl.create(:source, label: 'some file')
    visit sources_path

    click_link 'Supprimer'

    expect(current_path).to eq sources_path
    expect(page.body).to_not include 'some file'
  end
end
