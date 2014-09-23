class AddCompanyAndTelNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :company,    :string
    add_column :users, :tel_number, :string
  end
end
