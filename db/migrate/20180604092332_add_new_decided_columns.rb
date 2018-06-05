class AddNewDecidedColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_temporary_password, :boolean
    add_column :organisations, :is_setup_complete, :boolean
  end
end
