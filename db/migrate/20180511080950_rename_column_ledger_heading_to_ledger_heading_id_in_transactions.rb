class RenameColumnLedgerHeadingToLedgerHeadingIdInTransactions < ActiveRecord::Migration[5.0]
  def change
    rename_column :transactions, :ledger_heading, :ledger_heading_id
  end
end
