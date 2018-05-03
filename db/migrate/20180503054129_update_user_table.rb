class UpdateUserTable < ActiveRecord::Migration[5.0]
  def change
    # add_column :org_id, :integer need to add when organisationtabel created
    add_column :users, :mob_num, :string
    add_column :users, :address, :string
    add_column :users, :role, :string
    add_column :users, :status, :string
    add_column :users, :encrypted_password, :string

    remove_column :users, :reset_password_sent_at, :datetime
    remove_column :users, :remember_created_at, :datetime
    remove_column :users, :sign_in_count, :integer
    remove_column :users, :current_sign_in_at, :datetime
    remove_column :users, :last_sign_in_at, :datetime
    remove_column :users, :current_sign_in_ip, :string
    remove_column :users, :last_sign_in_ip, :string
    remove_column :users, :reset_password_token, :string

    # remove_index :users, :reset_password_token

  end
end
