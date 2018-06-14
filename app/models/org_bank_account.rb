# == Schema Information
#
# Table name: org_bank_accounts
#
#  id              :integer          not null, primary key
#  organisation_id :integer
#  bank_id         :integer
#  account_num     :string
#  deleted         :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  bank_balance    :decimal(, )
#  initial_balance :decimal(, )      default(0.0)
#  financial_year  :decimal(, )
#

class OrgBankAccount < ApplicationRecord
  belongs_to :orgnanisation, optional: true
  belongs_to :bank, optional: true
  has_one :org_bank_account_balance_summary

  scope :acnts_with_financial_year, lambda { |fy| where("org_bank_accounts.financial_year = ?", fy)}

  validates_presence_of :account_num, message: "Please enter valid Account Number"
  validates_presence_of :bank_id

  accepts_nested_attributes_for :org_bank_account_balance_summary


end
