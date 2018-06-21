class RemoveResetTokenFromUserTable < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :reset_token_at
  end
end
