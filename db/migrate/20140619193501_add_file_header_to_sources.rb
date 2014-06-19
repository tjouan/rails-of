class AddFileHeaderToSources < ActiveRecord::Migration
  def change
    add_column :sources, :file_header, :boolean, null: false, default: false
  end
end
