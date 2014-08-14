class AddDescriptionToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :description, :text
  end
end
