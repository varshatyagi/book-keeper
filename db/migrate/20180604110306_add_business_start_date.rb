class AddBusinessStartDate < ActiveRecord::Migration[5.0]
  def change
    add_column :organisations, :business_start_date, :datetime
  end
end
