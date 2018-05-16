class OrgBankAccount < ApplicationRecord
  # belongs_to :organisation
  # has_many :bank
  has_many :transactions
  validates_presence_of :account_num
  validates_presence_of :bank_id
end
