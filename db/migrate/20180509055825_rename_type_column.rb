class RenameTypeColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :ledger_headings, :type, :transcation_type
  end
end
