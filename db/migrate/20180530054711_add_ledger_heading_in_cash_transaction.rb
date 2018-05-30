class AddLedgerHeadingInCashTransaction < ActiveRecord::Migration[5.0]
  def change
    add_column :cash_transactions, :ledger_heading_id, :integer
  end
end
