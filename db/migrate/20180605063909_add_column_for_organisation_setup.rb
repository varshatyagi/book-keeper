class AddColumnForOrganisationSetup < ActiveRecord::Migration[5.0]
  def change
    rename_column :org_bank_account_balance_summaries, :initial_balance, :opening_balance
    add_column :org_bank_accounts, :opening_date, :datetime
  end
end
