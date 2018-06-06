class AddOrgBankAccountBalanceSummary < ActiveRecord::Migration[5.0]
  def change
    create_table :org_bank_account_balance_summaries do |t|
      t.integer "org_bank_account_id"
      t.decimal "opening_balance"
      t.decimal "current_balance"

      t.timestamps
    end

    add_foreign_key :org_bank_account_balance_summaries, :org_bank_accounts

    remove_column :org_bank_accounts, :initial_balance
    remove_column :org_bank_accounts, :bank_balance


  end
end
