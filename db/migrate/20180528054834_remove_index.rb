class RemoveIndex < ActiveRecord::Migration[5.0]
  def change
    remove_index :users, :city
    remove_index :users, :state_code
  end
end
