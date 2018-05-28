class AddColumnInOrgBankAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :org_bank_accounts, :initial_balance, :decimal, default: 0
    add_column :org_bank_accounts, :financial_year, :decimal
  end
end
