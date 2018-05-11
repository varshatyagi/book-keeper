class Transaction < ApplicationRecord
  belongs_to :ledger_heading
  belongs_to :bank
  belongs_to :payment_mode
end
