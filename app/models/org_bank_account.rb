# == Schema Information
#
# Table name: org_bank_accounts
#
#  id           :integer          not null, primary key
#  org_id       :integer
#  bank_id      :integer
#  account_num  :string
#  deleted      :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  bank_balance :decimal(, )
#

class OrgBankAccount < ApplicationRecord
  has_many :transactions
  validates_presence_of :account_num, message: "Please enter valid Account Number"
  validates_uniqueness_of :account_num, message: "Account number should be unique"
  validates_presence_of :bank_id
end
