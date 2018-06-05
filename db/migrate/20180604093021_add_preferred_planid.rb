class AddPreferredPlanid < ActiveRecord::Migration[5.0]
  def change
    add_column :organisations, :preferred_plan_id, :integer
  end
end
