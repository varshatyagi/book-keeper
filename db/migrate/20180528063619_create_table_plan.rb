class CreateTablePlan < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.integer "organisation_id"
      t.integer "plan"
      t.datetime "plan_start_date"

      t.timestamps
    end
  end
end
