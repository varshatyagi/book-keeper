class AddColumnLedgerDirectionInLedgerHeading < ActiveRecord::Migration[5.0]
  def change
    add_column :ledger_headings, :ledger_direction, :string
  end
end
