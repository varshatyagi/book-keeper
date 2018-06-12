# == Schema Information
#
# Table name: org_balances
#
#  id                     :integer          not null, primary key
#  organisation_id        :integer
#  cash_opening_balance   :decimal(10, 2)
#  bank_opening_balance   :decimal(10, 2)
#  credit_opening_balance :decimal(10, 2)
#  financial_year_start   :datetime
#  cash_balance           :decimal(10, 2)
#  bank_balance           :decimal(10, 2)
#  credit_balance         :decimal(10, 2)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_org_balances_on_organisation_id  (organisation_id)
#

class OrgBalance < ApplicationRecord
  belongs_to :organisation, optional: true

  before_create :calulate_financial_year
  before_update :manage_cash_balance

  scope :by_financial_year, lambda { |fy| where("org_balances.financial_year_start = ?", fy)}

  def calulate_financial_year
    Common.calulate_financial_year
  end

  def manage_cash_balance
    org_balance.cash_balance = org_balance.cash_balance
    org_balance.cash_opening_balance = org_balance.cash_opening_balance
    org_balance.save!
  end

end
