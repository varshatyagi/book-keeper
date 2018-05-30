class AddIndexesOnLedgerHeading < ActiveRecord::Migration[5.0]
  def change
    add_index :ledger_headings, :name
    add_index :ledger_headings, :transaction_type
    add_index :ledger_headings, :revenue
    add_index :ledger_headings, :asset
  end
end
