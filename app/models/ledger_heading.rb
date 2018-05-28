# == Schema Information
#
# Table name: ledger_headings
#
#  id               :integer          not null, primary key
#  name             :string
#  revenue          :boolean          default(FALSE)
#  transaction_type :string
#  asset            :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class LedgerHeading < ApplicationRecord

  # validates_presence_of :revenue, message: "Either Revenue or Asset must have vlalue", unless: :asset
  # validates_presence_of :asset, message: "Either Revenue or Asset must have vlalue", unless: :revenue
  # validates_presence_of :name, message: "Ledger Heading is required"
  # validates_uniqueness_of :name, message: "Ledger Heading is already exist"


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
