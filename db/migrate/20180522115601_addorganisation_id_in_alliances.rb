class AddorganisationIdInAlliances < ActiveRecord::Migration[5.0]
  def change
    add_column :alliances, :organisation_id, :integer
  end
end
