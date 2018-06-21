class AddOpeningDateInOrgaBankAccounts < ActiveRecord::Migration[5.0]
  def change
    remove_column :org_bank_account_balance_summaries, :opening_date
  end
end
