# == Schema Information
#
# Table name: otps
#
#  id         :integer          not null, primary key
#  mobile_num :string
#  otp_pin    :string
#  created_at :datetime
#

class Otp < ApplicationRecord

  validates_presence_of :mobile_num, message: 'Mobile Number is missing.'
end
