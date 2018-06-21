class RemoveTokenFromUserTable < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :token
  end
end
