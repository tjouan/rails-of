module AcceptanceHelpers
  def create_source(file: '3col_header.csv', header: false)
    visit new_source_path
    if header
      check 'en-tête'
    else
      uncheck 'en-tête'
    end
    attach_file 'source_file', File.join(fixture_path, file)
    click_button 'Enregistrer'
  end
end
