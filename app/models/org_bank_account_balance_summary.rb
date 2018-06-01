class OrgBankAccountBalanceSummary < ApplicationRecord
  belongs_to :org_bank_account, optional: true

  before_create :set_financial_year
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

  def set_financial_year
    self.financial_year = calulate_current_financial_year(financial_year) if self.financial_year.blank?
  end

  def calulate_current_financial_year(financial_year)
    if financial_year_start.present?
      financial_year = Time.parse(financial_year).year
      financial_year = DateTime.new(financial_year, 4, 1, 00, 00, 0)
    else
      financial_year = DateTime.new(Date.today.year, 4, 1, 00, 00, 0)
    end
  end

end
