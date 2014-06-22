class AddRefToOperations < ActiveRecord::Migration
  class Operation < ActiveRecord::Base
  end

  def change
    add_column :operations, :ref, :string

    Operation.reset_column_information

    reversible do |dir|
      dir.up { Operation.update_all('ref = lower(name)') }
    end
  end
end
