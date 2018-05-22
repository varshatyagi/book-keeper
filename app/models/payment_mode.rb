# == Schema Information
#
# Table name: payment_modes
#
#  id   :integer          not null, primary key
#  name :string
#

class PaymentMode < ApplicationRecord
  has_many :transactions
end
