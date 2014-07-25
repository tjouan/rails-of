require 'spec_helper'

feature 'Sources CRUD' do
  scenario 'lists sources' do
    create :source, label: 'some file'
    create :source, label: 'other file'

    visit sources_path

    expect(page).to have_content /some file.+other file/m
  end

  scenario 'shows source' do
    create :source, label: 'some file'

    visit sources_path
    click_link 'some file'

    expect(page).to have_content 'some file'
  end

  scenario 'creates source' do
    visit sources_path

    click_link 'Ajouter'
    fill_in 'Label', with: 'some file'
    attach_file 'source_file', File.join(fixture_path, 'mydata.csv').to_s
    click_button 'Enregistrer'

    expect(current_path).not_to eq new_source_path
    expect(page).to have_content 'some file'
  end

  scenario 'edits source' do
    create :source
    visit sources_path

    click_link 'Modifier'
    fill_in 'Label', with: 'a new label'
    click_button 'Enregistrer'

    expect(current_path).to eq sources_path
    expect(page).to have_content 'a new label'
  end

  scenario 'destroys source' do
    create :source
    visit sources_path

    click_link 'Supprimer'

    expect(current_path).to eq sources_path
    expect(page).not_to have_content 'some file'
  end
end
