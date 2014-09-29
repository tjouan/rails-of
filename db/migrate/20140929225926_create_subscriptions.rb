class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.timestamps

      t.references  :user,  index: true, null: false
      t.references  :offer, index: true, null: false
      t.datetime    :start_at
      t.datetime    :end_at
    end
  end
end
