class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.timestamps

      t.string :label, null: false
      t.string :description

      t.string :sha256, null: false
      t.string :file_name
      t.string :mime_type
    end
  end
end
