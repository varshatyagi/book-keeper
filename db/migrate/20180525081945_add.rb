class Add < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :city
    add_index :users, :state_code
  end
end
