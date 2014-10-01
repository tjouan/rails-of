class AddHelpToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :help_intent, :text
    add_column :operations, :help_usage,  :text
  end
end
