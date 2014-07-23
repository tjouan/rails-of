class AddResultsToWorks < ActiveRecord::Migration
  def change
    add_column :works, :results, :json
  end
end
