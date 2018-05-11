class Bank < ApplicationRecord
  has_many :transactions
  # belongs_to :org_bank_account
end
