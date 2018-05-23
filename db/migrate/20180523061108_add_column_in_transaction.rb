class AddColumnInTransaction < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :organisation_id, :integer
  end
end
