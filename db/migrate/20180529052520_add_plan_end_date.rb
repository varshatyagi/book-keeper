class AddPlanEndDate < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :plan_end_date, :datetime
  end
end
