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
  has_many :org_bank_account_balance_summaries

  validates_presence_of :account_num, message: "Please enter valid Account Number"
  validates_presence_of :bank_id

  accepts_nested_attributes_for :org_bank_account_balance_summaries
  after_create :create_org_bank_accnt_balance_summaries

  def create_org_bank_accnt_balance_summaries
    if opening_date.present?
      fy_of_opening_date = Common.calulate_financial_year(fy: opening_date)
    else
      fy_of_opening_date = Common.calulate_financial_year
    end
    fy_arr = Common.prepare_finanacial_year(fy_of_opening_date)
    fy_arr.each do |fy|
      OrgBankAccountBalanceSummary.create({
        financial_year: fy[:fy],
        org_bank_account_id: id,
        bank_balance: 0.0,
        opening_balance: 0.0
      })
    end
  end

end
