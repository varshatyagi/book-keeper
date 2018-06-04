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

  def update_balance
    raise 'Organisation not found' unless Organisation.find_by!(id: organisation.id)
    org_bank_acnt_balance = OrgBankAccountBalanceSummary.find_by(org_bank_account_id: org_bank_account.id)
    if withdrawal?
      org_bank_acnt_balance.bank_balance -= amount
      organisation.org_balance.cash_balance += amount
      organisation.org_balance.bank_balance -= amount
    else
      org_bank_acnt_balance.bank_balance += amount
      organisation.org_balance.cash_balance -= amount
      organisation.org_balance.bank_balance += amount
    end

    org_bank_acnt_balance.save!
    organisation.org_balance.save!
  end
end
