require 'spec_helper'

feature 'Works CRUD' do
  let(:operation) { build :operation }
  let(:source)    { build :source }
  let(:work)      { build :work }

  before          { visit root_path }

  context 'index' do
    before do
      work.save!
      click_link 'Analyses'
    end

    scenario 'lists works' do
      expect(page.body).to include work.operation.name
    end
  end

  context 'creation' do
    before do
      operation.save!
      source.save!
      click_link 'Analyses'
      click_link operation.name
    end

    scenario 'shows form' do
      expect(page).to have_select(
        'work[source_id]',
        with_options: [source.label]
      )
    end

    scenario 'select source' do
      select(source.label, from: 'Fichier')
      click_button 'Paramétrer'

      expect(page.body).to include operation.name
    end

    scenario 'creates work' do
      click_button 'Paramétrer'
      click_button 'Démarrer'

      expect(current_path).to eq works_path
      expect(page.body).to include source.label
    end
  end
end
