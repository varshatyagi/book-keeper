class UpdateColumnname < ActiveRecord::Migration[5.0]
  def change
    rename_column :org_bank_account_balance_summaries, :opening_balance, :bank_balance
    rename_column :org_bank_account_balance_summaries, :current_balance, :initial_balance
  end
end
