class AddDecimalDigits < ActiveRecord::Migration[5.0]
  def change
    change_column :transactions, :amount, :decimal, precision: 10, scale: 2

    change_column :sp_entries, :gst_total, :decimal, precision: 10, scale: 2
    change_column :sp_entry_items, :amount, :decimal, precision: 10, scale: 2
    change_column :sp_entry_items, :gst_amt, :decimal, precision: 10, scale: 2
    change_column :sp_entry_items, :gst_rate, :decimal, precision: 10, scale: 2

    change_column :gst_masters, :rate, :decimal, precision: 10, scale: 2

    change_column :cash_transactions, :amount, :decimal, precision: 10, scale: 2

    change_column :org_balances, :cash_opening_balance, :decimal, precision: 10, scale: 2
    change_column :org_balances, :bank_opening_balance, :decimal, precision: 10, scale: 2
    change_column :org_balances, :credit_opening_balance, :decimal, precision: 10, scale: 2
    change_column :org_balances, :cash_balance, :decimal, precision: 10, scale: 2
    change_column :org_balances, :bank_balance, :decimal, precision: 10, scale: 2
    change_column :org_balances, :credit_balance, :decimal, precision: 10, scale: 2

  end
end
