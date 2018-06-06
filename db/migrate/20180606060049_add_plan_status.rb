class AddPlanStatus < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :status, :string
  end
end
