class OrgBankAccount < ApplicationRecord
  # belongs_to :organisation
  # has_many :bank
  has_many :transactions
end
