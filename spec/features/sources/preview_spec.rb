require 'spec_helper'

feature 'Sources preview' do
  include AcceptanceHelpers

  background do
    sign_in
    create_source
    click_icon 'Preview'
  end

  scenario 'shows header preview' do
    expect(page.all('.sources-preview th').map(&:text)).to eq %w[
      name  score active
    ]
  end

  scenario 'shows rows preview' do
    expect(page.all('.sources-preview td').map(&:text)).to eq %w[
      foo   42    1
      bar   13    1
      baz   32    0
    ]
  end
end
