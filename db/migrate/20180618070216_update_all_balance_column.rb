class UpdateAllBalanceColumn < ActiveRecord::Migration[5.0]
  def change
    change_column :org_balances, :credit_opening_balance, :decimal, :null => false, :default => 0
    change_column :org_balances, :credit_balance, :decimal, :null => false, :default => 0
    change_column :org_balances, :bank_opening_balance, :decimal, :null => false, :default => 0
    change_column :org_balances, :bank_balance, :decimal, :null => false, :default => 0
    change_column :org_balances, :debit_balance, :decimal, :null => false, :default => 0
    change_column :org_balances, :debit_opening_balance, :decimal, :null => false, :default => 0
    change_column :org_balances, :cash_balance, :decimal, :null => false, :default => 0
    change_column :org_balances, :cash_opening_balance, :decimal, :null => false, :default => 0
  end
end
