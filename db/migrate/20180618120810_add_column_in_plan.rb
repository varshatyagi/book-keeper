class AddColumnInPlan < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :remarks, :string
  end
end
