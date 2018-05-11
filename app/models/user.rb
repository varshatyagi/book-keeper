class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable
         # :recoverable, :rememberable, :trackable, :validatable
  validates_presence_of :email, message: 'Please provide email.'
  validates_presence_of :mob_num, message: 'Please provide mobile number.'
  validates_presence_of :name, message: 'Please provide Username.'
  # validates_presence_of :password, message: 'Please provide password.'

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, message: "Email is not in correct format."
  validates_format_of :mob_num, :with => /\A\d{10}\z/, message: "Please enter valid mobile number."

   validates_uniqueness_of :email, message: 'Email id is already exist.'
end
