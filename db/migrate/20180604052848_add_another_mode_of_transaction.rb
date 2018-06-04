class AddAnotherModeOfTransaction < ActiveRecord::Migration[5.0]
  def change
    add_column :org_balances, :debit_balance, :decimal, precision: 10, scale: 2
    add_column :org_balances, :debit_opening_balance, :decimal, precision: 10, scale: 2
  end
end
