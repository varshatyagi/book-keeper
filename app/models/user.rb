# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  organisation_id    :integer
#  name               :string
#  mob_num            :string
#  email              :string
#  address            :string
#  city               :string
#  state_code         :string
#  role               :string
#  status             :string
#  created_by         :integer
#  encrypted_password :string
#  token              :string
#  reset_token_at     :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_users_on_organisation_id  (organisation_id)
#

class User < ApplicationRecord
  devise :database_authenticatable, :registerable
  has_one :organisation, foreign_key: :owner_id
  accepts_nested_attributes_for :organisation

  validates_uniqueness_of :mob_num, message: "Mobile Number has already been taken", allow_blank: true
  validates_uniqueness_of :email, message: "Email has already been taken", allow_blank: true

  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, message: "Please provide valid email address", allow_blank: true
  validates_format_of :mob_num, with: /\A\d{10}\z/, message: "Please provide valid mobile number.", allow_blank: true

  before_save :downcase_fields

  USER_ROLE_CLIENT = 'client'
  USER_ROLE_ADMIN = 'admin'

  USER_STATUS_ACTIVE = 'active'
  USER_STATUS_PENDING = 'pending'

  BASE_URL = "https://online-acc.herokuapp.com/r?code="
  FORGOT_PASSWORD_URL = "https://online-acc.herokuapp.com/forgot-password"
  LOGIN_URL = "https://online-acc.herokuapp.com/login"

  def admin?
    role == USER_ROLE_ADMIN
  end

  def client?
    role == USER_ROLE_CLIENT
  end

  def downcase_fields
    email.downcase! if email.present?
  end
end
