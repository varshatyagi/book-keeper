class V1::SessionController < ApplicationController

  require "rubygems"
  require "net/https"
  require "uri"
  require "json"

  def sign_up
    if signUpParams
      user = User.new(signUpParams)
      if user.valid?
        begin
          ApplicationRecord.transaction do
            if otpParams[:otp].present?
              unless isOtpValid(otpParams) == false
                render json: {error: 'Otp is not valid', status: false, response: nil}
                return
              end
              otpRecord = Otp.find_by({mobile_num: signUpParams[:mob_num]})
              otpRecord.destroy!
            end
            ApplicationRecord.transaction do
              organisation = Organisation.new(name: organisationParams[:name])
              organisation.save!
              ApplicationRecord.transaction do
                user[:org_id] = organisation.id
                user.save!
                ApplicationRecord.transaction do
                  organisation.update_attributes!({created_by: user.id, user_id: user.id})
                end
              end
            end
          end
        rescue StandardError => error
          render json: {errors: error}, status: 400
          return
        end
        render json: {errors: nil, status: true, response: {user: generateToken(user)}}, status: Helper::HTTP_CODE[:SUCCESS]
      else
        render json: {errors: user.errors.messages, status: false, response: nil}, status: Helper::HTTP_CODE[:BAD_REQUEST]
      end
    else
      render json: Helper::MISSING_ENTRIES, status: Helper.HTTP_CODE[:BAD_REQUEST]
    end
  end

  def login
    if otpParams[:mob_num] && otpParams[:otp]
      render json: loginViaOTP(otpParams)
    elsif authParams[:email] && authParams[:password]
      render json: loginViaEmail(authParams)
    else
      render json: Helper::ACCESS_DENIED, status: Helper::HTTP_CODE[:UNAUTHORIZE]
    end
  end

  def loginViaEmail(options)
    user = User.find_by(email: options[:email])
    if user
      if user.valid_password? options[:password]
        return {errors: nil, status: true, response: {user: generateToken(user)}}
      end
    else
      return Helper::ACCESS_DENIED
    end
  end

  def loginViaOTP(options)
    unless isOtpValid(options) == true
      return {error: 'Otp is not valid', status: false, response: nil}
    end
    user = User.find_by(mob_num: options[:mob_num])
    if user
      otpRecord = Otp.find_by({mobile_num: options[:mob_num]})
      otpRecord.destroy
      return {errors: nil, status: true, response: {user: generateToken(user)}}
    else
      return {errors: ['Please register yourself first'], status: true, response: nil}
    end
  end

  def getOtp
    ifExist = Otp.find_by({mobile_num: otpParams[:mob_num]})
    if ifExist
      notExpired = (Time.now.to_i - ifExist.created_at.to_i) < Helper::OTP_EXPIRATION_TIME
      if notExpired
        render json: {errors: nil, status: true, response: {otp: ifExist[:otp_pin]}}, status: Helper::HTTP_CODE[:SUCCESS]
        return
      end
    end
    render json: generateOtpPin(otpParams[:mob_num])
  end


  def logout
  end

  def generateOtpPin(mobNum)
    requested_url = Rails.configuration.SMS[:URI]
    uri = URI.parse(requested_url)
    http = Net::HTTP.start(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    sendSms = Otp.new(mobile_num: mobNum, created_at: Time.now, otp_pin: rand(0000..9999).to_s.rjust(4, "0"))
    sendSms.save
    res = Net::HTTP.post_form(uri, 'apikey' => Rails.configuration.SMS[:API_KEY], 'message' => sendSms[:otp_pin], 'numbers' => 9479674736, 'test' => true)
    response = JSON.parse(res.body)
    response
  end

  def isOtpValid(options)
    otpObj = Otp.find_by({mobile_num: options[:mob_num]})
    unless otpObj
      return false
    end
    notExpired = (Time.now.to_i - otpObj[:created_at].to_i) > Helper::OTP_EXPIRATION_TIME
    notExpired
  end

  private

    def otpParams
      params.require(:otp).permit(:mob_num, :otp)
    end
    def authParams
      params.require(:user).permit(:email, :password, :mob_num)
    end

    def signUpParams
      params.require(:user).permit(:email, :password, :mob_num, :name)
    end

    def organisationParams
      params.require(:organisation).permit(:name)
    end

    def generateToken(currentUser)
      jwt = Auth.encode({user: currentUser.id}) # get token
      currentUser.update_attributes(token: jwt, reset_token_at: Time.now)
      currentUser
    end

end
