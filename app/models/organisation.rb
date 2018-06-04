# == Schema Information
#
# Table name: organisations
#
#  id             :integer          not null, primary key
#  name           :string
#  org_type       :string
#  address        :string
#  city           :string
#  state_code     :string
#  status         :string
#  created_by     :integer
#  owner_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  active_plan_id :integer
#
# Indexes
#
#  index_organisations_on_active_plan_id  (active_plan_id)
#  index_organisations_on_owner_id        (owner_id)
#

class Organisation < ApplicationRecord
  has_many :org_bank_accounts
  belongs_to :user, optional: true, foreign_key: 'owner_id'
  has_one :org_balance
  has_many :cash_transactions
  has_many :transactions
  belongs_to :plan, optional: true

  accepts_nested_attributes_for :org_bank_accounts

  after_create :create_org_balance

  validates_uniqueness_of :name, message: "Business name has already been taken", if: :name_present?

  def name_present?
    name.present?
  end

  def create_org_balance
    OrgBalance.create({
        organisation_id: self.id,
        cash_opening_balance: 0.0,
        bank_opening_balance: 0.0,
        credit_opening_balance: 0.0,
        financial_year_start: Common.calulate_current_financial_year,
        cash_balance: 0.0,
        bank_balance: 0.0,
        credit_balance: 0.0,
        debit_balance: 0.0,
        debit_opening_balance: 0.0
      })
  end
end
