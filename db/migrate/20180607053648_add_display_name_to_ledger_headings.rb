class AddDisplayNameToLedgerHeadings < ActiveRecord::Migration[5.0]
  def change
    add_column :ledger_headings, :display_name, :string
  end

end
