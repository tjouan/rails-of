class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column          :users, :admin, :boolean, default: false
    change_column_null  :users, :admin, false
  end
end
