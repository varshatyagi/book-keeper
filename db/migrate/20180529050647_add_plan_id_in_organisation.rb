class AddPlanIdInOrganisation < ActiveRecord::Migration[5.0]
  def change
    add_column :organisations, :active_plan_id, :integer
  end
end
