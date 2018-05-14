class User < ApplicationRecord
  has_many :organisations

  devise :database_authenticatable, :registerable
  validates_presence_of :email, message: 'Please provide email.'
  validates_presence_of :name, message: 'Please provide Username.'

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, message: "Email is not in correct format."
  validates_format_of :mob_num, :with => /\A\d{10}\z/, message: "Please enter valid mobile number."

  validates_uniqueness_of :email, message: 'Email id is already exist.'
end
