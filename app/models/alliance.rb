# == Schema Information
#
# Table name: alliances
#
#  id                   :integer          not null, primary key
#  name                 :string
#  gstin                :string
#  alliance_type        :string
#  status               :string
#  mob_num              :string
#  alter_mob_num        :string
#  email                :string
#  alter_email          :string
#  land_line            :string
#  address              :string
#  city                 :string
#  state_code           :string
#  contact_person       :string
#  alter_contact_person :string
#  created_by           :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  organisation_id      :integer
#
# Indexes
#
#  index_alliances_on_organisation_id  (organisation_id)
#

class Alliance < ApplicationRecord
  belongs_to :organisation, optional: true
  has_many :transactions

  validates_uniqueness_of :mob_num, message: "Mobile Number has already been taken", allow_blank: true
  validates_uniqueness_of :email, message: "Email has already been taken", allow_blank: true

  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, message: "Please provide valid email address", allow_blank: true
  validates_format_of :mob_num, with: /\A\d{10}\z/, message: "Please provide valid mobile number.", allow_blank: true

  validates_uniqueness_of :gstin, message: "Gstin has already been taken"
  validates_presence_of :gstin, message: "Please provide Gstin number"


  DEBITOR = 'debtor'
  CREDITOR = 'creditor'
end
