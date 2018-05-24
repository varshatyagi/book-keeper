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
  belongs_to :alliances, optional: true

  after_create :update_balance

  STATUS = {
    "COMPLETED": "Completed",
    "PENDING": "Pending",
    "FAILED": "Failed"
  }

  def update_balance
    org_bank_account = OrgBankAccount.find(self.org_bank_account_id)
    raise 'Organisation Bank is not exist' unless org_bank_account.present?

    org_balance = OrgBalance.find_by(organisation_id: self.organisation_id)
    raise 'Organisation Opening balance record is not exist' unless org_balance.present?

    ledger_heading = LedgerHeading.find(self.ledger_heading_id)
    raise 'Ledger Heading is not exist' unless ledger_heading.present?

    if ledger_heading[:transaction_type] == "credit"
      if self.payment_mode == 'bank'
        org_balance.bank_balance = org_balance[:bank_balance] + self.amount
        org_bank_account.bank_balance = org_bank_account[:bank_balance] + self.amount
        org_bank_account.save!
      elsif self.payment_mode == 'credit'
        org_balance.credit_balance = org_balance[:credit_balance] + self.amount
      elsif self.payment_mode == 'cash'
        org_balance.cash_balance = org_balance[:cash_balance] + self.amount
      end
    end

    if ledger_heading[:transaction_type] == "debit"
      if self.payment_mode == 'bank'
        org_bank_account.bank_balance = org_bank_account[:bank_balance] - self.amount
        org_balance.bank_balance = org_balance[:bank_balance] - self.amount
        org_bank_account.save!
      elsif self.payment_mode == 'credit'
        org_balance.credit_balance = org_balance[:credit_balance] - self.amount
      elsif self.payment_mode == 'cash'
        org_balance.cash_balance = org_balance[:cash_balance] - self.amount
      end
    end

    org_balance.save!
  end

end
