class AddActiveToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :active, :boolean, null: false, default: true
  end
end
