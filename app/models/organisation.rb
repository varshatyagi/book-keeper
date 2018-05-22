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
  belongs_to :user, optional: true, foreign_key: 'owner_id'
  has_one :org_balance

  after_create :create_org_balance
  validate :validate_organisation

  def create_org_balance
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

  def validate_organisation
    if self.name.blank?
      self.errors.add(:name, message: 'Please provide your organisation name')
      
    elsif self.name.present?
      self.errors.add(:name, message: 'Organisation name has already been taken') if Organisation.find_by(name: self.name)
    end
  end
end
