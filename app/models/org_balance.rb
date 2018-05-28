# == Schema Information
#
# Table name: org_balances
#
#  id                     :integer          not null, primary key
#  organisation_id        :integer
#  cash_opening_balance   :decimal(, )
#  bank_opening_balance   :decimal(, )
#  credit_opening_balance :decimal(, )
#  financial_year_start   :datetime
#  cash_balance           :decimal(, )
#  bank_balance           :decimal(, )
#  credit_balance         :decimal(, )
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class OrgBalance < ApplicationRecord
  belongs_to :organisation, optional: true
end
