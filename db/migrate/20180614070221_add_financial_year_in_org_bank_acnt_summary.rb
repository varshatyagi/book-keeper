class AddFinancialYearInOrgBankAcntSummary < ActiveRecord::Migration[5.0]
  def change
    add_column :org_bank_account_balance_summaries, :financial_year, :datetime
    remove_column :org_bank_accounts, :financial_year
    add_column :org_bank_account_balance_summaries, :opening_date, :datetime
  end
end
