class AddIndexesOnOrgBalance < ActiveRecord::Migration[5.0]
  def change
    add_index :org_balances, :organisation_id
  end
end
