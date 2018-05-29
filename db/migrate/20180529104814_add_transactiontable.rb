class AddTransactiontable < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.integer  "ledger_heading_id"
      t.decimal  "amount"
      t.string   "remarks"
      t.string   "payment_mode"
      t.datetime "txn_date"
      t.string   "status"
      t.integer  "created_by"
      t.integer  "org_bank_account_id"
      t.integer  "organisation_id"
      t.integer  "alliance_id"
      t.timestamps
    end
  end
end
