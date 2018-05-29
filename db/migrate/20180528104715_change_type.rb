class ChangeType < ActiveRecord::Migration[5.0]
  def change
    change_column :transactions, :ledger_heading_id, 'integer USING CAST(ledger_heading_id AS integer)'
  end
end
