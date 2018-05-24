# == Schema Information
#
# Table name: ledger_headings
#
#  id               :integer          not null, primary key
#  name             :string
#  revenue          :boolean
#  transaction_type :string
#  asset            :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class LedgerHeading < ApplicationRecord

  TRANSACTION_TYPE_REVENUE = 'revenue'
  TRANSACTION_TYPE_ASSET = 'asset'
  TRANSACTION_TYPE_CREDIT = 'credit'
  TRANSACTION_TYPE_DEBIT = 'debit'

  def debit?
    transaction_type == TRASACTION_TYPE_DEBIT
  end

  def credit?
    transaction_type == TRASACTION_TYPE_CREDIT
  end
end
