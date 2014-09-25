class AddCharsetToSources < ActiveRecord::Migration
  def up
    add_column :sources, :charset, :string

    Source.update_all(charset: 'utf-8')
  end

  def down
    remove_column :sources, :charset
  end
end
