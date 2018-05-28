# == Schema Information
#
# Table name: otps
#
#  id         :integer          not null, primary key
#  mob_num    :string
#  otp_pin    :string
#  created_at :datetime
#

class Otp < ApplicationRecord

  validates_presence_of :mob_num, with: /\A\d{10}\z/, message: "Please provide mobile number."
  validates_format_of :mob_num, with: /\A\d{10}\z/, message: "Please provide valid mobile number."
  validates_presence_of :otp_pin, message: "Please provide otp."

  OTP_EXPIRATION_TIME = 3600 # In seconds 24 hrs
end
