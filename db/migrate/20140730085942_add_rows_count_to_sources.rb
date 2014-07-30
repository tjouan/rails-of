class AddRowsCountToSources < ActiveRecord::Migration
  def change
    add_column :sources, :rows_count, :integer
  end
end
