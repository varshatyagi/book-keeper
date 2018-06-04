# == Schema Information
#
# Table name: payment_modes
#
#  id   :integer          not null, primary key
#  name :string
#

class PaymentMode < ApplicationRecord
  PAYMENT_MODE_BANK = 'bank'
  PAYMENT_MODE_CREDIT = 'credit'
  PAYMENT_MODE_CASH = 'cash'
  PAYMENT_MODE_DEBIT = 'debit'
end
