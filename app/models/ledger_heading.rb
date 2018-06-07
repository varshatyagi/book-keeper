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
# Indexes
#
#  index_ledger_headings_on_asset             (asset)
#  index_ledger_headings_on_name              (name)
#  index_ledger_headings_on_revenue           (revenue)
#  index_ledger_headings_on_transaction_type  (transaction_type)
#

class LedgerHeading < ApplicationRecord

  validates_presence_of :revenue, message: "Either Revenue or Asset must have value", unless: :asset
  validates_presence_of :asset, message: "Either Revenue or Asset must have value", unless: :revenue
  validates_presence_of :name, message: "Ledger Heading is required"

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
