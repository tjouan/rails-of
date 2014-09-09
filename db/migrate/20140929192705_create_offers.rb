class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.timestamps

      t.string  :name
      t.string  :ref
      t.decimal :price, precision: 6, scale: 2
      t.boolean :visible, default: false
    end
  end
end
