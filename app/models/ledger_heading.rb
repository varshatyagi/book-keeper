# == Schema Information
#
# Table name: ledger_headings
#
#  id               :integer          not null, primary key
#  name             :string
#  revenue          :boolean
#  transcation_type :string
#  asset            :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class LedgerHeading < ApplicationRecord
  has_many :transactions

  TRASACTION_TYPE_REVENUE = 'revenue'
  TRASACTION_TYPE_ASSET = 'asset'
  TRASACTION_TYPE_CREDIT = 'credit'
  TRASACTION_TYPE_DEBIT = 'debit'

  def debit?
    transaction_type == TRASACTION_TYPE_DEBIT
  end

  def credit?
    transaction_type == TRASACTION_TYPE_CREDIT 
  end
end
