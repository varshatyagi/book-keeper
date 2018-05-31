class AddIndexesOnTransaction < ActiveRecord::Migration[5.0]
  def change
    add_index :transactions, :txn_date
    add_index :transactions, :ledger_heading_id
    add_foreign_key :transactions, :ledger_headings
    add_foreign_key :transactions, :organisations
    add_foreign_key :transactions, :org_bank_account_id
    add_foreign_key :transactions, :alliances
  end
end
