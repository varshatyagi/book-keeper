# == Schema Information
#
# Table name: otps
#
#  id         :integer          not null, primary key
#  mob_num :string
#  otp_pin    :string
#  created_at :datetime
#

class Otp < ApplicationRecord

  validate :validate_otp
  OTP_EXPIRATION_TIME = 360000000000 # In seconds 24 hrs

  def validate_otp
    if self.mob_num.present? && !self.mob_num.match(/\A\d{10}\z/)
      self.errors.add(:mob_num, :invalid, message: 'Please provide valid mobile number')
    end

    if self.mob_num.blank?
      self.errors.add(:mob_num, message: 'please provide mobile number')
    end

  end
end
