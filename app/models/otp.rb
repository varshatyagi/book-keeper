class Otp < ApplicationRecord

  validates_presence_of :mobile_num, message: 'Mobile Number is missing.'
end
