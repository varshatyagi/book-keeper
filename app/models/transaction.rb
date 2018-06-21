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

  STATUS = {
    "COMPLETED": "Completed",
    "PENDING": "Pending",
    "FAILED": "Failed"
  }

  REVERT_TRANSACTION = 'revert transaction'
  UPDATE_TRANSACTION = 'update transaction'

  def update_balance(direction)

    org_balance = organisation.org_balances.by_financial_year(Common.calulate_financial_year(fy: self.txn_date)).first
    org_bank_summary = OrgBankAccountBalanceSummary.where(org_bank_account_id: org_bank_account_id).acnts_with_financial_year(Common.calulate_financial_year(fy: txn_date)).first
    raise 'Transaction can not be done outside of the financial year of Organization Bank Accounts.' unless org_balance.present?

    transaction_type = LedgerHeading.find(ledger_heading_id).transaction_type
    case payment_mode
    when PaymentMode::PAYMENT_MODE_BANK
      update_bank_balances(transaction_type, org_balance, org_bank_summary, amount, direction)
    when PaymentMode::PAYMENT_MODE_DEBIT
      update_credit_debit_balances(transaction_type, org_balance, amount, direction)
    when PaymentMode::PAYMENT_MODE_CASH
      update_cash_balances(transaction_type, org_balance, amount, direction)
    when PaymentMode::PAYMENT_MODE_CREDIT
      update_credit_debit_balances(transaction_type, org_balance, amount, direction)
    else
    end

    if ledger_heading.name == LedgerHeading::CREDIT_PAYMENT || ledger_heading.name == LedgerHeading::DEBIT_PAYMENT
      org_balance = manage_balance_in_special_case(ledger_heading.name, org_balance, direction, amount)
    end

    org_balance.save!
  end

  def update_bank_balances(transaction_type, org_balance, bank_summary, amount, direction)
    if transaction_type == LedgerHeading::TRANSACTION_TYPE_CREDIT
      if direction == Transaction::UPDATE_TRANSACTION
        org_balance.bank_balance += amount
        bank_summary.bank_balance += amount
        bank_summary.save!
      elsif direction == Transaction::REVERT_TRANSACTION
        org_balance.bank_balance -= amount
        bank_summary.bank_balance -= amount
        bank_summary.save!
      end
    elsif transaction_type == LedgerHeading::TRANSACTION_TYPE_DEBIT
      if direction == Transaction::UPDATE_TRANSACTION
        org_balance.bank_balance -= amount
        bank_summary.bank_balance -= amount
        bank_summary.save!
      elsif direction == Transaction::REVERT_TRANSACTION
        org_balance.bank_balance += amount
        bank_summary.bank_balance += amount
        bank_summary.save!
      end
    end

  end

  def update_credit_debit_balances(transaction_type, org_balance, amount, direction)
    if transaction_type == LedgerHeading::TRANSACTION_TYPE_CREDIT
      if direction == Transaction::UPDATE_TRANSACTION
        org_balance.debit_balance += amount
      elsif direction == Transaction::REVERT_TRANSACTION
        org_balance.debit_balance -= amount
      end
    elsif transaction_type == LedgerHeading::TRANSACTION_TYPE_DEBIT
      if direction == Transaction::UPDATE_TRANSACTION
        org_balance.credit_balance += amount
      elsif direction == Transaction::REVERT_TRANSACTION
        org_balance.credit_balance -= amount
      end
    end
  end

  def update_cash_balances(transaction_type, org_balance, amount, direction)
    if transaction_type == LedgerHeading::TRANSACTION_TYPE_CREDIT
      if direction == Transaction::UPDATE_TRANSACTION
        org_balance.cash_balance += amount
      elsif direction == Transaction::REVERT_TRANSACTION
        org_balance.cash_balance -= amount
      end
    elsif transaction_type == LedgerHeading::TRANSACTION_TYPE_DEBIT
      if direction == Transaction::UPDATE_TRANSACTION
        org_balance.cash_balance -= amount
      elsif direction == Transaction::REVERT_TRANSACTION
        org_balance.cash_balance += amount
      end
    end
  end

  def manage_balance_in_special_case(ledger_heading, org_balance, direction, amount)
    case ledger_heading
    when LedgerHeading::CREDIT_PAYMENT
    org_balance.credit_balance -= amount if direction == Transaction::UPDATE_TRANSACTION
    org_balance.credit_balance += amount if direction == Transaction::REVERT_TRANSACTION
    when LedgerHeading::DEBIT_PAYMENT
    org_balance.debit_balance -= amount if direction == Transaction::UPDATE_TRANSACTION
    org_balance.debit_balance += amount if direction == Transaction::REVERT_TRANSACTION
    else
    end
    org_balance
  end

end
