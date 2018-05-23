class OrganisationColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :cash_transactions, :organisation_id, :integer
  end
end
