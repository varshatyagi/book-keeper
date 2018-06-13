class UpdateTypeOfFinancailYear < ActiveRecord::Migration[5.0]
  def change
    remove_column :org_bank_accounts, :financial_year
    add_column :org_bank_accounts, :financial_year, :datetime
  end
end
