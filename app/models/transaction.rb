# == Schema Information
#
# Table name: transactions
#
#  id                  :integer          not null, primary key
#  ledger_heading_id   :integer
#  amount              :decimal(, )
#  remarks             :string
#  payment_mode        :string
#  txn_date            :datetime
#  status              :string
#  created_by          :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  org_bank_account_id :integer
#

class Transaction < ApplicationRecord
  belongs_to :ledger_heading, optional: true
  belongs_to :org_bank_account, optional: true
  # belongs_to :payment_mode


end
