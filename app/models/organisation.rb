# == Schema Information
#
# Table name: organisations
#
#  id         :integer          not null, primary key
#  name       :string
#  org_type   :string
#  address    :string
#  city       :string
#  state_code :string
#  status     :string
#  created_by :integer
#  owner_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_organisations_on_name      (name) UNIQUE
#  index_organisations_on_owner_id  (owner_id)
#

class Organisation < ApplicationRecord
  has_many :org_bank_accounts
  belongs_to :user, optional: true, foreign_key: 'owner_id'
  has_one :org_balance
  has_many :cash_transactions
  has_many :transactions

  accepts_nested_attributes_for :org_bank_accounts

  after_create :create_org_balance

  validates_presence_of :name, message: "Please provide your Business name"
  validates_uniqueness_of :name, message: "Business name has already been taken"

  def create_org_balance
    OrgBalance.create({
        organisation_id: self.id,
        cash_opening_balance: 0.0,
        bank_opening_balance: 0.0,
        credit_opening_balance: 0.0,
        financial_year_start: Time.now,
        cash_balance: 0.0,
        bank_balance: 0.0,
        credit_balance: 0.0
      })
  end

  def update_org_balance_with_opening_balance(opening_balance, params, org_params)
    OrgBalance.create({
        organisation_id: params[:id],
        cash_opening_balance: 0,
        bank_opening_balance: opening_balance,
        credit_opening_balance: 0,
        financial_year_start: org_params[:financial_year],
        cash_balance: 0,
        bank_balance: opening_balance,
        credit_balance: 0
    })
  end
end
