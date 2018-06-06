# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180606060049) do

  create_table "alliances", force: :cascade do |t|
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
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "organisation_id"
    t.index ["organisation_id"], name: "index_alliances_on_organisation_id"
  end

  create_table "banks", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cash_transactions", force: :cascade do |t|
    t.decimal  "amount",              precision: 10, scale: 2
    t.integer  "org_bank_account_id"
    t.boolean  "withdrawal"
    t.datetime "txn_date"
    t.string   "remarks"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "organisation_id"
    t.integer  "ledger_heading_id"
    t.index ["ledger_heading_id"], name: "index_cash_transactions_on_ledger_heading_id"
    t.index ["org_bank_account_id"], name: "index_cash_transactions_on_org_bank_account_id"
    t.index ["organisation_id"], name: "index_cash_transactions_on_organisation_id"
    t.index ["txn_date"], name: "index_cash_transactions_on_txn_date"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.string "state_code"
  end

  create_table "gst_categories", force: :cascade do |t|
    t.string "name"
  end

  create_table "gst_masters", force: :cascade do |t|
    t.string   "name"
    t.integer  "categaory_id"
    t.boolean  "goods"
    t.decimal  "rate",         precision: 10, scale: 2
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "ledger_headings", force: :cascade do |t|
    t.string   "name"
    t.boolean  "revenue",          default: false
    t.string   "transaction_type"
    t.boolean  "asset",            default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["asset"], name: "index_ledger_headings_on_asset"
    t.index ["name"], name: "index_ledger_headings_on_name"
    t.index ["revenue"], name: "index_ledger_headings_on_revenue"
    t.index ["transaction_type"], name: "index_ledger_headings_on_transaction_type"
  end

  create_table "org_balances", force: :cascade do |t|
    t.integer  "organisation_id"
    t.decimal  "cash_opening_balance",   precision: 10, scale: 2
    t.decimal  "bank_opening_balance",   precision: 10, scale: 2
    t.decimal  "credit_opening_balance", precision: 10, scale: 2
    t.datetime "financial_year_start"
    t.decimal  "cash_balance",           precision: 10, scale: 2
    t.decimal  "bank_balance",           precision: 10, scale: 2
    t.decimal  "credit_balance",         precision: 10, scale: 2
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.decimal  "debit_balance",          precision: 10, scale: 2
    t.decimal  "debit_opening_balance",  precision: 10, scale: 2
    t.index ["organisation_id"], name: "index_org_balances_on_organisation_id"
  end

  create_table "org_bank_account_balance_summaries", force: :cascade do |t|
    t.integer  "org_bank_account_id"
    t.decimal  "bank_balance"
    t.decimal  "opening_balance"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "org_bank_accounts", force: :cascade do |t|
    t.integer  "organisation_id"
    t.integer  "bank_id"
    t.string   "account_num"
    t.boolean  "deleted",         default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.datetime "financial_year"
    t.datetime "opening_date"
  end

  create_table "organisations", force: :cascade do |t|
    t.string   "name"
    t.string   "org_type"
    t.string   "address"
    t.string   "city"
    t.string   "state_code"
    t.string   "status"
    t.integer  "created_by"
    t.integer  "owner_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "active_plan_id"
    t.boolean  "is_setup_complete"
    t.integer  "preferred_plan_id"
    t.datetime "business_start_date"
    t.index ["active_plan_id"], name: "index_organisations_on_active_plan_id"
    t.index ["owner_id"], name: "index_organisations_on_owner_id"
  end

  create_table "otps", force: :cascade do |t|
    t.string   "mob_num"
    t.string   "otp_pin"
    t.datetime "created_at"
    t.index ["mob_num", "otp_pin"], name: "index_otps_on_mob_num_and_otp_pin", unique: true
  end

  create_table "payment_modes", force: :cascade do |t|
    t.string "name"
  end

  create_table "plans", force: :cascade do |t|
    t.integer  "organisation_id"
    t.integer  "plan"
    t.datetime "plan_start_date"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.datetime "plan_end_date"
    t.decimal  "amount",          precision: 10, scale: 2
    t.string   "status"
    t.index ["organisation_id"], name: "index_plans_on_organisation_id"
    t.index ["plan_start_date"], name: "index_plans_on_plan_start_date"
  end

  create_table "sp_entries", force: :cascade do |t|
    t.string   "bill_no"
    t.datetime "entry_date"
    t.string   "status"
    t.string   "gstin"
    t.string   "party"
    t.string   "mob_num"
    t.string   "payment_mode"
    t.decimal  "gst_total",    precision: 10, scale: 2
    t.integer  "created_by"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "sp_entry_items", force: :cascade do |t|
    t.integer  "entry_id"
    t.string   "item_name"
    t.string   "status"
    t.integer  "quanity"
    t.decimal  "amount",                precision: 10, scale: 2
    t.integer  "gst_master_id"
    t.decimal  "gst_amt",               precision: 10, scale: 2
    t.decimal  "gst_rate",              precision: 10, scale: 2
    t.datetime "gst_rate_updated_when"
    t.integer  "created_by"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "states", force: :cascade do |t|
    t.string "code"
    t.string "name"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "ledger_heading_id"
    t.decimal  "amount",              precision: 10, scale: 2
    t.string   "remarks"
    t.string   "payment_mode"
    t.datetime "txn_date"
    t.string   "status"
    t.integer  "created_by"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "org_bank_account_id"
    t.integer  "organisation_id"
    t.integer  "alliance_id"
    t.index ["ledger_heading_id"], name: "index_transactions_on_ledger_heading_id"
    t.index ["txn_date"], name: "index_transactions_on_txn_date"
  end

  create_table "users", force: :cascade do |t|
    t.integer  "organisation_id"
    t.string   "name"
    t.string   "mob_num"
    t.string   "email"
    t.string   "address"
    t.string   "city"
    t.string   "state_code"
    t.string   "role"
    t.string   "status"
    t.integer  "created_by"
    t.string   "encrypted_password"
    t.string   "token"
    t.datetime "reset_token_at"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.boolean  "is_temporary_password"
    t.index ["organisation_id"], name: "index_users_on_organisation_id"
  end

end
