class ChangeType < ActiveRecord::Migration[5.0]
  def change
    change_column :transactions, :ledger_heading_id, :integer
  end
end
