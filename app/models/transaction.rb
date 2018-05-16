class Transaction < ApplicationRecord
  belongs_to :ledger_heading, optional: true
  belongs_to :org_bank_account, optional: true
  # belongs_to :payment_mode


end
