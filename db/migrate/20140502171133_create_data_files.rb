class CreateDataFiles < ActiveRecord::Migration
  def change
    create_table :data_files do |t|
      t.string :label
      t.string :description

      t.timestamps
    end
  end
end
