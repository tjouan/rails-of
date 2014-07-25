module AcceptanceHelpers
  def create_source(file: '3col_header.csv', header: false)
    @_uploaded_source_file_path = uploaded_source_path file

    visit new_source_path
    if header
      check 'en-tête'
    else
      uncheck 'en-tête'
    end
    attach_file 'source_file', @_uploaded_source_file_path
    click_button 'Enregistrer'
  end

  def uploaded_source_file
    File.new(@_uploaded_source_file_path)
  end


  private

  def uploaded_source_path(file_name)
    File.join(fixture_path, file_name)
  end
end
