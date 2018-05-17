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

ActiveRecord::Schema.define(version: 20180517062040) do

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
  end

  create_table "banks", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cash_transactions", force: :cascade do |t|
    t.decimal  "amount"
    t.integer  "org_bank_account_id"
    t.boolean  "withdrawal"
    t.datetime "txn_date"
    t.string   "remarks"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
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
    t.decimal  "rate"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "ledger_headings", force: :cascade do |t|
    t.string   "name"
    t.boolean  "revenue"
    t.string   "transcation_type"
    t.boolean  "asset"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "org_balances", force: :cascade do |t|
    t.integer  "org_id"
    t.decimal  "cash_opening_balance"
    t.decimal  "bank_opening_balance"
    t.decimal  "credit_opening_balance"
    t.datetime "financial_year_start"
    t.decimal  "cash_balance"
    t.decimal  "bank_balance"
    t.decimal  "credit_balance"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "org_bank_accounts", force: :cascade do |t|
    t.integer  "org_id"
    t.integer  "bank_id"
    t.string   "account_num"
    t.boolean  "deleted"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.decimal  "bank_balance"
  end

  create_table "organisations", force: :cascade do |t|
    t.string   "name"
    t.string   "org_type"
    t.string   "address"
    t.string   "city"
    t.string   "state_code"
    t.string   "status"
    t.integer  "created_by"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_organisations_on_name", unique: true
  end

  create_table "otp", force: :cascade do |t|
    t.string   "mobile_num"
    t.string   "message"
    t.datetime "created_at"
  end

  create_table "otps", force: :cascade do |t|
    t.string   "mobile_num"
    t.string   "otp_pin"
    t.datetime "created_at"
  end

  create_table "payment_modes", force: :cascade do |t|
    t.string "name"
  end

  create_table "sp_entries", force: :cascade do |t|
    t.string   "bill_no"
    t.datetime "entry_date"
    t.string   "status"
    t.string   "gstin"
    t.string   "party"
    t.string   "mob_num"
    t.string   "payment_mode"
    t.decimal  "gst_total"
    t.integer  "created_by"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "sp_entry_items", force: :cascade do |t|
    t.integer  "entry_id"
    t.string   "item_name"
    t.string   "status"
    t.integer  "quanity"
    t.decimal  "amount"
    t.integer  "gst_master_id"
    t.decimal  "gst_amt"
    t.decimal  "gst_rate"
    t.datetime "gst_rate_updated_when"
    t.integer  "created_by"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "states", force: :cascade do |t|
    t.string "code"
    t.string "name"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "ledger_heading_id"
    t.decimal  "amount"
    t.string   "remarks"
    t.string   "payment_mode"
    t.datetime "txn_date"
    t.string   "status"
    t.integer  "created_by"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "org_bank_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer  "org_id"
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
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

end
