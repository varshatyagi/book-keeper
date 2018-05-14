class Organisation < ApplicationRecord
  has_many :org_bank_account
  belongs_to :user, optional: true
  belongs_to :org_balance, optional: true
  
  validates_presence_of :name, message: 'Please provide Organisation name.'
  validates_uniqueness_of :name
end
