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
end
