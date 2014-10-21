class AddQuotaToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :quota, :integer, null: false, default: 50_0000
  end
end
