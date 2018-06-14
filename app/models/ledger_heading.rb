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

  validates_presence_of :display_name, message: "Ledger Heading name is required"

  TRANSACTION_TYPE_REVENUE = 'revenue'
  TRANSACTION_TYPE_ASSET = 'asset'
  TRANSACTION_TYPE_CREDIT = 'credit'
  TRANSACTION_TYPE_DEBIT = 'debit'

  CREDIT_PAYMENT = 'CREDIT_PAYMENT'
  DEBIT_PAYMENT = 'DEBIT_PAYMENT'

  CASH_TRANSACTION = "cash_transaction"

  before_create :create_name_for_ledger_heading

  def debit?
    transaction_type == TRASACTION_TYPE_DEBIT
  end

  def credit?
    transaction_type == TRASACTION_TYPE_CREDIT
  end

  def create_name_for_ledger_heading
    display_name = self.display_name
    self.name = display_name.gsub(/( )/, '_').upcase
  end
end
