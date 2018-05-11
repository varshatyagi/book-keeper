class UpdateForeignColumnname < ActiveRecord::Migration[5.0]
  def change
    rename_column :transactions, :bank_id, :org_bank_account_id
  end
end
