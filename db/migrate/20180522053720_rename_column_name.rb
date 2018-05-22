class RenameColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :org_balances, :org_id, :organisation_id
    rename_column :org_bank_accounts, :org_id, :organisation_id
    rename_column :organisations, :user_id, :owner_id
    add_index :organisations, :owner_id

  end
end
