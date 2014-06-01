class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.timestamps

      t.string :name, null: false
    end
  end
end
