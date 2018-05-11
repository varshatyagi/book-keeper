class UpdateOrgcolumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :org_balances, :org_Id, :org_id
  end
end
