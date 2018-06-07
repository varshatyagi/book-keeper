class RemoveStatusColumnFromPlan < ActiveRecord::Migration[5.0]
  def change
    remove_column :plans, :status
  end
end
