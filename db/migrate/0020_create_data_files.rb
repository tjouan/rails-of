class CreateDataFiles < ActiveRecord::Migration
  def change
    create_table :data_files do |t|
      t.timestamps

      t.string :label
      t.string :description

      t.string :sha256
      t.string :file_name
      t.string :mime_type

      t.hstore :header
    end
  end
end
