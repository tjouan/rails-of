require 'spec_helper'

feature 'Works CRUD' do
  let(:operation) { build :operation }
  let(:source)    { build :source }

  before do
    operation.save!
    source.save!
    visit operations_path
    click_link operation.name
  end

  scenario 'lists works' do
    work = create :work
    visit works_path

    expect(page.body).to include work.operation.name
  end

  context 'creation' do
    scenario 'shows form' do
      expect(page).to have_select(
        'work[source_id]',
        with_options: [source.label]
      )
    end

    scenario 'creates work' do
      select(source.label, from: 'Fichier')
      click_button 'Enregistrer'

      expect(page.body).to include operation.name
    end
  end
end
