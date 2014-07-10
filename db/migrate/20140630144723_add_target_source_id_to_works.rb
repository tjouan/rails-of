class AddTargetSourceIdToWorks < ActiveRecord::Migration
  def change
    add_column :works, :target_source_id, :integer
  end
end
