# == Schema Information
#
# Table name: cash_transactions
#
#  id                  :integer          not null, primary key
#  amount              :decimal(10, 2)
#  org_bank_account_id :integer
#  withdrawal          :boolean
#  txn_date            :datetime
#  remarks             :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  organisation_id     :integer
#  ledger_heading_id   :integer
#
# Indexes
#
#  index_cash_transactions_on_ledger_heading_id    (ledger_heading_id)
#  index_cash_transactions_on_org_bank_account_id  (org_bank_account_id)
#  index_cash_transactions_on_organisation_id      (organisation_id)
#  index_cash_transactions_on_txn_date             (txn_date)
#

class CashTransaction < ApplicationRecord
  belongs_to :organisation, optional: true
  belongs_to :org_bank_account, optional: true

  after_create :update_balance

  WITHDRAWAL = "WITHDRAWAL"
  DEPOSIT = "DEPOSIT"

  def update_balance

    organisation = Organisation.find(org_bank_account.organisation_id) || not_found
    org_balance = organisation.org_balances.by_financial_year(Common.calulate_financial_year(fy: self.txn_date)).first

    org_bank_acnt_balance = OrgBankAccountBalanceSummary.find_by(org_bank_account_id: org_bank_account.id)
    if withdrawal?
      org_bank_acnt_balance.bank_balance -= amount
      org_balance.cash_balance += amount
      org_balance.bank_balance -= amount
    else
      org_bank_acnt_balance.bank_balance += amount
      org_balance.cash_balance -= amount
      org_balance.bank_balance += amount
    end

    org_bank_acnt_balance.save!
    org_balance.save!
  end
end
