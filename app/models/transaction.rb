# == Schema Information
#
# Table name: transactions
#
#  id                  :integer          not null, primary key
#  ledger_heading_id   :integer
#  amount              :decimal(10, 2)
#  remarks             :string
#  payment_mode        :string
#  txn_date            :datetime
#  status              :string
#  created_by          :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  org_bank_account_id :integer
#  organisation_id     :integer
#  alliance_id         :integer
#
# Indexes
#
#  index_transactions_on_ledger_heading_id  (ledger_heading_id)
#  index_transactions_on_txn_date           (txn_date)
#

class Transaction < ApplicationRecord
  belongs_to :ledger_heading, optional: true
  belongs_to :organisation, optional: true
  belongs_to :org_bank_account, optional: true
  belongs_to :alliance, optional: true

  after_create :update_balance

  STATUS = {
    "COMPLETED": "Completed",
    "PENDING": "Pending",
    "FAILED": "Failed"
  }

  def update_balance

    org_balance = organisation.org_balances.by_financial_year(Common.calulate_financial_year(fy: self.txn_date)).first

    if payment_mode == PaymentMode::PAYMENT_MODE_BANK
      org_bank_rec = organisation.org_bank_accounts.display_acnts_with_financial_year(Common.calulate_financial_year(fy: self.txn_date))
      org_bank_rec = org_bank_rec.where(id: org_bank_account_id).first
      org_bank_balance_summary_rec = OrgBankAccountBalanceSummary.find_by(org_bank_account_id: org_bank_rec.id)
    end

    if ledger_heading.transaction_type == LedgerHeading::TRANSACTION_TYPE_CREDIT
      if payment_mode == PaymentMode::PAYMENT_MODE_BANK
        org_balance.bank_balance += amount
        org_bank_balance_summary_rec.bank_balance += amount
        org_bank_balance_summary_rec.save!
      elsif payment_mode == PaymentMode::PAYMENT_MODE_DEBIT
        org_balance.debit_balance += amount
      elsif payment_mode == PaymentMode::PAYMENT_MODE_CASH
        org_balance.cash_balance += amount
      end
    elsif ledger_heading[:transaction_type] == LedgerHeading::TRANSACTION_TYPE_DEBIT
      if payment_mode == PaymentMode::PAYMENT_MODE_BANK
        org_balance.bank_balance -= amount
        org_bank_balance_summary_rec.bank_balance -= amount
        org_bank_balance_summary_rec.save!
      elsif payment_mode == PaymentMode::PAYMENT_MODE_CREDIT
        org_balance.credit_balance += amount
      elsif payment_mode == PaymentMode::PAYMENT_MODE_CASH
        org_balance.cash_balance -= amount
      end
    end

    org_balance.save!
  end

end
