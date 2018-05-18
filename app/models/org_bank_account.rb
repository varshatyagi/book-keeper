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
  # belongs_to :organisation
  # has_many :bank
  has_many :transactions
  validates_presence_of :account_num
  validates_presence_of :bank_id
end
