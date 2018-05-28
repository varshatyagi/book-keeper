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
  # TODO fix this
  validate :validate_otp

  validates_presence_of :mob_num, with: /\A\d{10}\z/, message: "Please provide mobile number."
  validates_format_of :mob_num, with: /\A\d{10}\z/, message: "Please provide valid mobile number."
  validates_presence_of :otp_pin, message: "Please provide otp."

  OTP_EXPIRATION_TIME = 3600 # In seconds 24 hrs

  def validate_otp
    if self.mob_num.present? && !self.mob_num.match(/\A\d{10}\z/)
      self.errors.add(:mob_num, :invalid, message: 'Please provide valid mobile number')
    end

    if self.mob_num.blank?
      self.errors.add(:mob_num, message: 'Please provide mobile number')
    end

    if self.otp_pin.blank?
      self.errors.add(:otp_pin, message: 'Please provide valid Otp')
    end

  end
end
