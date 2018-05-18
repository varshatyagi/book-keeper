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
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_organisations_on_name  (name) UNIQUE
#

class Organisation < ApplicationRecord
  has_many :org_bank_accounts
  belongs_to :user, optional: true
  has_one :org_balance

  validates_presence_of :name
  validates_uniqueness_of :name, message: 'Orgainsation name has already been taken.'

  after_create :insertRecordInOrgBalance

  def insertRecordInOrgBalance
    OrgBalance.create({
        org_id: self.id,
        cash_opening_balance: 0.0,
        bank_opening_balance: 0.0,
        credit_opening_balance: 0.0,
        financial_year_start: Time.now,
        cash_balance: 0.0,
        bank_balance: 0.0,
        credit_balance: 0.0
      })
  end
end
