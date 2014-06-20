class AddPositionToHeaders < ActiveRecord::Migration
  def change
    add_column :headers, :position, :integer, null: false
  end
end
