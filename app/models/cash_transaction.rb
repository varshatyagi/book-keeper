# == Schema Information
#
# Table name: cash_transactions
#
#  id                  :integer          not null, primary key
#  amount              :decimal(, )
#  org_bank_account_id :integer
#  withdrawal          :boolean
#  txn_date            :datetime
#  remarks             :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class CashTransaction < ApplicationRecord
end
