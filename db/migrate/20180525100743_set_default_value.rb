class SetDefaultValue < ActiveRecord::Migration[5.0]
  def change
    change_column :ledger_headings, :revenue, :boolean, default: false
    change_column :ledger_headings, :asset, :boolean, default: false
    change_column :org_bank_accounts, :deleted, :boolean, default: false
  end
end
