class AddColumnInUsres < ActiveRecord::Migration[5.0]
  def change
    # add_column :org_id, :integer need to add when organisationtabel created
    add_column :users, :mob_num, :string
    add_column :users, :address, :string
    add_column :users, :role, :string
    add_column :users, :status, :string
    add_column :users, :token, :string, null: true
    add_column :users, :created_by, :integer, default: 0
    add_column :users, :reset_password_token_at, :datetime, null: true
  end
end
