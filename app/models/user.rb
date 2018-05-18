# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  org_id             :integer
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

class User < ApplicationRecord
  has_many :organisations

  devise :database_authenticatable, :registerable
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, message: "Email is not in correct format.", :allow_blank => true
  validates_format_of :mob_num, with: /\A\d{10}\z/, message: "Please enter valid mobile number.", :allow_blank => true

  validates_uniqueness_of :email, message: 'Email id is already exist.', allow_blank: true
  # validates_uniqueness_of :mob_num, allow_blank: true

  USER_ROLE_CLIENT = 'client'
  USER_ROLE_ADMIN = 'admin'

  TOKEN_EXPIRATION_TIME = 86400 # In seconds 24 hrs

  def admin?
    role == USER_ROLE_ADMIN
  end

  def client?
    role == USER_ROLE_CLIENT
  end

  def token_expired?
    (Time.now.to_i - reset_token_at.to_i) > TOKEN_EXPIRATION_TIME
  end

end
