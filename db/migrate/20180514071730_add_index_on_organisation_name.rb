class AddIndexOnOrganisationName < ActiveRecord::Migration[5.0]
  def change
    add_index :organisations, :name, :unique => true
  end
end
