class AddIndexesOnTables < ActiveRecord::Migration[5.0]
  def change
    add_index :cash_transactions, :org_bank_account_id
    add_index :cash_transactions, :organisation_id
    add_index :cash_transactions, :ledger_heading_id
    add_index :cash_transactions, :txn_date

    add_index :alliances, :organisation_id
    add_index :organisations, :active_plan_id
    add_index :plans, :organisation_id
    add_index :plans, :plan_start_date

    add_index :users, :organisation_id
  end
end
