class PaymentMode < ApplicationRecord
  has_many :transactions
end
