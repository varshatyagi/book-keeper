class AddColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :org_bank_accounts, :bank_balance, :decimal
    add_column :transactions, :bank_id, :integer
    change_column :transactions, :ledger_heading, 'integer USING CAST(ledger_heading AS integer)'
  end
end
