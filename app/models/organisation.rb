class Organisation < ApplicationRecord
  has_many :org_bank_account
  belongs_to :user
  belongs_to :org_balance
end
