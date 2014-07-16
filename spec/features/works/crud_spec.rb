require 'spec_helper'

feature 'Works CRUD' do
  let(:operation) { build :operation }
  let(:work)      { build :work }

  background      { visit root_path }

  context 'index' do
    background do
      work.save!
      click_link 'Tableau de bord'
    end

    scenario 'lists works' do
      expect(page).to have_content work.operation.name
    end
  end

  context 'creation' do
    include AcceptanceHelpers

    background do
      operation.save!
      create_source
      click_link 'Tableau de bord'
      click_link operation.name
    end

    scenario 'shows form' do
      expect(page).to have_select(
        'work[source_id]',
        with_options: ['3col_header.csv']
      )
    end

    scenario 'selects source' do
      select('3col_header.csv', from: 'Données')
      click_button 'Paramétrer'

      expect(page).to have_content operation.name
    end

    scenario 'creates work' do
      click_button 'Paramétrer'
      click_button 'Démarrer'

      expect(current_path).to eq works_path
      expect(page).to have_content '3col_header.csv'
    end
  end
end
