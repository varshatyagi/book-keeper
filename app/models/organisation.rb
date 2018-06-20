# == Schema Information
#
# Table name: organisations
#
#  id             :integer          not null, primary key
#  name           :string
#  org_type       :string
#  address        :string
#  city           :string
#  state_code     :string
#  status         :string
#  created_by     :integer
#  owner_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  active_plan_id :integer
#
# Indexes
#
#  index_organisations_on_active_plan_id  (active_plan_id)
#  index_organisations_on_owner_id        (owner_id)
#

class Organisation < ApplicationRecord
  has_many :org_bank_accounts
  belongs_to :user, optional: true, foreign_key: 'owner_id'
  has_many :org_balances
  has_many :cash_transactions
  has_many :transactions
  has_one :plan

  accepts_nested_attributes_for :org_bank_accounts
  accepts_nested_attributes_for :org_balances

  REPORT_TYPE_PROFIT_AND_LOSS = 'pl'
  REPORT_TYPE_ACCOUNT_LEDGER = 'account_ledger'
  REPORT_TYPE_BALANCE_SHEET = 'balance_sheet'

  def preferred_plan_name
    return "n/a" if preferred_plan_id.blank?
    Plan::PLAN_NAME[preferred_plan_id - 1]
  end

  def create_org_balances
    if business_start_date.present?
      fy_of_business_start_date = Common.calulate_financial_year(fy: business_start_date)
    else
      fy_of_business_start_date = Common.calulate_financial_year
    end
    fy_arr = Common.prepare_finanacial_year(fy_of_business_start_date)
    fy_arr.each do |fy|
      OrgBalance.create!({
        financial_year_start: fy[:fy],
        bank_balance: 0.0,
        bank_opening_balance: 0.0,
        cash_balance: 0.0,
        cash_opening_balance: 0.0,
        debit_balance: 0.0,
        debit_opening_balance: 0.0,
        organisation_id: id,
        credit_balance: 0.0,
        credit_opening_balance: 0.0
      })
    end

    capital_accrued_cash_ledger_id = LedgerHeading.find_by(name: LedgerHeading::CAPITAL_ACCRUED_CASH).id

    org_balance = org_balances.by_financial_year(Common.calulate_financial_year).first
    Transaction.create!({
      ledger_heading_id: capital_accrued_cash_ledger_id,
      amount: org_balance.cash_opening_balance.to_f,
      remarks: 'CAPITAL_ACCRUED_CASH',
      payment_mode: 'cash',
      txn_date: org_balance.created_at
    })
  end
end
