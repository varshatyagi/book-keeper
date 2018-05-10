class RenameAssestColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :ledger_headings, :Asset, :asset
  end
end
