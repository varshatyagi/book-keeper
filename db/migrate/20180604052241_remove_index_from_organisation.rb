class RemoveIndexFromOrganisation < ActiveRecord::Migration[5.0]
  def change
    remove_index :organisations, :name
  end
end
