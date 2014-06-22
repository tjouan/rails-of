class AddFailureTimestampsToWorks < ActiveRecord::Migration
  def change
    add_column :works, :failed_at,      :datetime
    add_column :works, :terminated_at,  :datetime
  end
end
