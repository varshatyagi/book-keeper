class OrgBankAccountBalanceSummary < ApplicationRecord
  belongs_to :org_bank_account, optional: true

  scope :acnts_with_financial_year, lambda { |fy| where("org_bank_account_balance_summaries.financial_year = ?", fy)}

  after_commit :update_total_balance, on: :create

  def update_total_balance
    return true unless bank_balance.present? && bank_balance > 0
    cur_bal = bank_balance
    org_bank_account = OrgBankAccount.find(org_bank_account_id)
    organisation = Organisation.find(org_bank_account.organisation_id)
    org_balance = organisation.org_balances.by_financial_year(Common.calulate_financial_year).first
    unless org_balance.bank_balance.nil?
      cur_bal += org_balance.bank_balance
    end
    org_balance.update_attributes!(bank_balance: cur_bal, bank_opening_balance: cur_bal)
  end

end
