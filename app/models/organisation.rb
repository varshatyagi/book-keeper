class Organisation < ApplicationRecord
  has_many :org_bank_account
  has_many :user
  belongs_to :org_balance
end
