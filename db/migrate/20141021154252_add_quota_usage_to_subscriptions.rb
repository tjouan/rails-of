class AddQuotaUsageToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :quota, :integer, null: false, default: 50_000
    add_column :subscriptions, :usage, :integer, null: false, default: 0
  end
end
