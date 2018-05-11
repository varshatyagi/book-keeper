class UpdateOwenerId < ActiveRecord::Migration[5.0]
  def change
    rename_column :organisations, :owner_id, :user_id
  end
end
