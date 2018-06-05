class AddAmountInpLans < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :amount, :decimal, precision: 10, scale: 2
  end
end
