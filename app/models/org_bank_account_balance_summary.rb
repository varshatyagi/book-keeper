class OrgBankAccountBalanceSummary < ApplicationRecord
  belongs_to :org_bank_account, optional: true

  after_create :update_total_balance

  def update_total_balance
    return true unless bank_balance.present? && bank_balance > 0
    cur_bal = bank_balance
    org_bank_account = OrgBankAccount.find(org_bank_account_id)
    organisation = Organisation.find(org_bank_account.organisation_id)

    unless organisation.org_balances.first.bank_balance.nil?
      cur_bal += organisation.org_balances.first.bank_balance
    end
    organisation.org_balances.first.update_attributes!(bank_balance: cur_bal, bank_opening_balance: cur_bal)
  end

end
