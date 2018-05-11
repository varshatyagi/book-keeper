class Transaction < ApplicationRecord
  belongs_to :ledger_heading
  belongs_to :org_bank_account, optional: true
  # belongs_to :payment_mode


end
