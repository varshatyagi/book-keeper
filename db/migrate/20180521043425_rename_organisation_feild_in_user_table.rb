class RenameOrganisationFeildInUserTable < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :org_id, :organisation_id
    rename_column :ledger_headings, :transcation_type, :transaction_type
  end
end
