class OrgBankAccountBalanceSummary < ApplicationRecord
  belongs_to :org_bank_account, optional: true

  after_create :update_total_bank_balance

  def update_total_bank_balance
    return true unless bank_balance.present? && bank_balance > 0
    cur_bal = bank_balance
    org_bank_account = OrgBankAccount.find(id)
    organisation = Organisation.find(org_bank_account.organisation_id)
    unless organisation.org_balance.bank_balance.nil?
      cur_bal += organisation.org_balance.bank_balance
    end
    organisation.org_balance.update_attributes!(bank_balance: cur_bal)
  end

end
