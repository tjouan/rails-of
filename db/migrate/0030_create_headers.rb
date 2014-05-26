class CreateHeaders < ActiveRecord::Migration
  def change
    create_table :headers do |t|
      t.references :source, null: false
      t.timestamps

      t.string  :name, null: false
      t.integer :type, null: false
    end
  end
end
