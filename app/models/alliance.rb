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
#

class Alliance < ApplicationRecord
  has_many :transactions
end
