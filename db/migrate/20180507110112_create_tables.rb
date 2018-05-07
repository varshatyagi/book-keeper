class CreateTables < ActiveRecord::Migration[5.0]
  def change

    create_table :users do |t|
      t.integer       "org_id"
      t.string        "name"
      t.string        "mob_num"
      t.string        "email"
      t.string        "address"
      t.string        "city"
      t.string        "state_code"
      t.string        "role"
      t.string        "status"
      t.integer       "created_by"
      t.string        "encrypted_password"
      t.string        "token"
      t.datetime      "reset_token_at"
      t.timestamps
    end

    create_table :ledger_headings do |t|
      t.string      "name"
      t.boolean     "revenue"
      t.string      "type"
      t.boolean     "Asset"
      t.timestamps
    end

    create_table :transactions do |t|
      t.string      "ledger_heading"
      t.decimal     "amount"
      t.string      "remarks"
      t.string      "payment_mode"
      t.datetime    "txn_date"
      t.string      "status"
      t.integer     "created_by"
      t.timestamps
    end

    create_table :payment_modes do |t|
      t.string      "name"
    end

    create_table :sp_entries do |t|
      t.string      "bill_no"
      t.datetime    "entry_date"
      t.string      "status"
      t.string      "gstin"
      t.string      "party"
      t.string      "mob_num"
      t.string      "payment_mode"
      t.decimal     "gst_total"
      t.integer     "created_by"
      t.timestamps
    end

    create_table :sp_entry_items do |t|
      t.integer     "entry_id"
      t.string      "item_name"
      t.string      "status"
      t.integer     "quanity"
      t.decimal     "amount"
      t.integer     "gst_master_id"
      t.decimal     "gst_amt"
      t.decimal     "gst_rate"
      t.datetime    "gst_rate_updated_when"
      t.integer     "created_by"
      t.timestamps
    end

    create_table :organisations do |t|
      t.string      "name"
      t.string      "org_type"
      t.string      "address"
      t.string      "city"
      t.string      "state_code"
      t.string      "status"
      t.integer     "created_by"
      t.integer     "owner_id"
      t.timestamps
    end

    create_table :alliances do |t|
      t.string   "name"
      t.string   "gstin"
      t.string   "alliance_type"
      t.string   "status"
      t.string   "mob_num"
      t.string   "alter_mob_num"
      t.string   "email"
      t.string   "alter_email"
      t.string   "land_line"
      t.string   "address"
      t.string   "city"
      t.string   "state_code"
      t.string   "contact_person"
      t.string   "alter_contact_person"
      t.integer  "created_by"
      t.timestamps
    end

    create_table :gst_masters do |t|
      t.string      "name"
      t.integer     "categaory_id"
      t.boolean     "goods"
      t.decimal     "rate"
      t.timestamps
    end

    create_table :cities do |t|
      t.string    "name"
      t.string    "state_code"
    end

    create_table :states do |t|
      t.string    "code"
      t.string    "name"
    end

    create_table :gst_categories do |t|
      t.string    "name"
    end

    create_table :org_bank_accounts do |t|
      t.integer  "org_id"
      t.integer  "bank_id"
      t.string   "account_num"
      t.boolean  "deleted"
      t.timestamps
    end

    create_table :banks do |t|
      t.string   "name"
      t.timestamps
    end

    create_table :cash_transactions do |t|
      t.decimal     "amount"
      t.integer     "org_bank_account_id"
      t.boolean     "withdrawal"
      t.datetime    "txn_date"
      t.string      "remarks"
      t.timestamps
    end

    create_table :org_balances do |t|
      t.integer     "org_Id"
      t.decimal     "cash_opening_balance"
      t.decimal     "bank_opening_balance"
      t.decimal     "credit_opening_balance"
      t.datetime    "financial_year_start"
      t.decimal     "cash_balance"
      t.decimal     "bank_balance"
      t.decimal     "credit_balance"
      t.timestamps
    end
  end
end
