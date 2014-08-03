class AddUserReferences < ActiveRecord::Migration
  def change
    add_reference :sources, :user, index: true, null: false
    add_reference :works,   :user, index: true, null: false
  end
end
