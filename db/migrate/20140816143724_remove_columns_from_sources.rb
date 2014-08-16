class RemoveColumnsFromSources < ActiveRecord::Migration
  def change
    remove_column :sources, :mime_type
    remove_column :sources, :charset
    remove_column :sources, :file_header
  end
end
