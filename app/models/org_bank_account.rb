# == Schema Information
#
# Table name: org_bank_accounts
#
#  id              :integer          not null, primary key
#  organisation_id :integer
#  bank_id         :integer
#  account_num     :string
#  deleted         :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  bank_balance    :decimal(, )
#

class OrgBankAccount < ApplicationRecord
  belongs_to :orgnanisation, optional: true
  belongs_to :bank
  has_many :transactions

  validates_presence_of :account_num, message: "Please enter valid Account Number"
  validates_uniqueness_of :account_num, message: "Account number should be unique"
  validates_presence_of :bank_id

  after_commit :update_total_bank_balance

  private
  def update_total_bank_balance
    return true unless bank_balance.present? && bank_balance > 0
    cur_bal = bank_balance
    organisation = Organisation.find(organisation_id)
    unless organisation.org_balance.bank_balance.nil?
      cur_bal += organisation.org_balance.bank_balance  
    end
    organisation.org_balance.update_attributes!(bank_balance: cur_bal)
  end
end
