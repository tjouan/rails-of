class CreateWork < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.references :operation,  null: false
      t.references :source,     null: false
      t.timestamps

      t.datetime :started_at
      t.datetime :processed_at
    end
  end
end
