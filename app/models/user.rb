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
  devise :database_authenticatable, :registerable
  has_many :organisations
  validate :validate_user

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

  def validate_user
    if self.email.present? && !self.email.match(URI::MailTo::EMAIL_REGEXP)
      self.errors.add(:email, message: 'Please provide valid email address')
    end

    if self.email.present?
      self.errors.add(:email, message: 'Email id has already been taken') if User.find_by({email: self.email})
    end

    if self.mob_num.present? && !self.mob_num.match(/\A\d{10}\z/)
      self.errors.add(:mob_num, :invalid, message: 'Please provide valid mobile number')
    end

    if self.mob_num.present?
      self.errors.add(:mob_num, message: 'Mobile number has already been taken') if User.find_by({mob_num: self.mob_num})
    end
  end

end
