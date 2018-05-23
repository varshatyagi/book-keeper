class AllianceId < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :alliance_id, :integer
  end
end
