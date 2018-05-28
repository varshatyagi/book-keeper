class V1::UsersController < ApplicationController

  require "rubygems"
  require "net/https"
  require "uri"
  require "json"


  def create
    user_sign_up_via_email = false
    organisation = Organisation.new(organisation_params)
    errors = []

    unless otp_params.present?
      user_sign_up_via_email = true
      user = User.new(user_params)
      errors << user.errors.values unless user.valid?
    end
    if !user_sign_up_via_email
      otp = Otp.new({mob_num: otp_params[:mob_num], otp_pin: otp_params[:otp_pin]})
      user = User.new(mob_num: otp_params[:mob_num])
      errors << otp.errors.values unless otp.valid?
    end
    errors << organisation.errors.values unless organisation.valid?
    errors = errors.flatten(3)
    return render json: {errors: errors}, status: 400 if errors.present?
    ApplicationRecord.transaction do
      unless user_sign_up_via_email
        raise 'Either Mobile number or Otp is not correct' unless Otp.find_by(mob_num: otp_params[:mob_num], otp_pin: otp_params[:otp_pin])
        otp_record = Otp.find_by(mob_num: otp_params[:mob_num])
        return render json:  {errors: ['Token is expired']} unless otp_record.present? && (Time.now.to_i - otp_record.created_at.to_i) < Otp::OTP_EXPIRATION_TIME
        otp_record.destroy!
      end
      user.role = User::USER_ROLE_CLIENT
      user.save!
      organisation.owner_id = user.id
      organisation.created_by = user.id
      organisation.save!
      user.organisation_id = organisation.id
      user.save(validate: false)
    end
    generate_token(user)
    render json: {response: {user: UserSerializer.new(user).serializable_hash}}, status: 200
  rescue StandardError => error
    render json: {errors: [error]}, status: 400
  end

  def show
    raise 'User is not found' unless User.find_by(id: params[:id]).present?
    user = User.find(params[:id])
    render json: {response: {user: UserSerializer.new(user).serializable_hash}}, status: 200
  end

  def update
    raise 'Requested Uesr is not found' unless User.find_by!(id: params[:id]).present?
    user = User.find_by(id: params[:id])
    user = user.update_attributes!(user_params)
    render json: {response: user}
  end

  def login
    if otp_params.present?
      has_user_obj = login_via_otp(otp_params)
      render json: has_user_obj, status: 401 if has_user_obj.kind_of?(Hash) && has_user_obj[:errors].present?
      render json: has_user_obj
    elsif user_params.present?
      has_user_obj = login_via_email(user_params)
      render json: has_user_obj, status: 401 if has_user_obj.kind_of?(Hash) && has_user_obj[:errors].present?
      render json: has_user_obj
    else
      render json: {errors: ['Your are not authorized to access this resource']}, status: 401
    end
  end

  def login_via_email(options)
    raise 'User is not registered with provided email id' unless User.find_by!(email: options[:email])
    user = User.find_by(email: options[:email])
    return {errors: ['password is not valid']} unless user.present? && (user.valid_password? options[:password])
    generate_token(user)
    return {response: {user: UserSerializer.new(user).serializable_hash}}
  end

  def login_via_otp(otp_params)
    raise 'Either Mobile Number or otp is invalid' unless Otp.find_by(mob_num: otp_params[:mob_num], otp_pin: otp_params[:otp_pin])
    otp_record = Otp.find_by(mob_num: otp_params[:mob_num])
    return {errors: ['Token is expired']} unless otp_record.present? && (Time.now.to_i - otp_record.created_at.to_i) < Otp::OTP_EXPIRATION_TIME
    raise 'User is not registered with this mobile number' unless User.find_by(mob_num: otp_params[:mob_num])
    user = User.find_by(mob_num: otp_params[:mob_num])
    otp_record.destroy
    generate_token(user)
    return {response: {user: UserSerializer.new(user).serializable_hash}}
  end

  def otp
    return render json: {errors: ['Mobile number is not registered']}, status: 400 if otp_params[:mob_num].blank?
    otp_record = Otp.find_by({mob_num: otp_params[:mob_num]})
    return render json: {response: {otp_pin: otp_record.otp_pin}} if otp_record.present? && (Time.now.to_i - otp_record.created_at.to_i) < Otp::OTP_EXPIRATION_TIME
    render json: {response: generate_otp_pin(otp_params[:mob_num])}
  end

  private

  def generate_token(current_user)
    jwt = Auth.encode({user: current_user.id, time: Time.now}) # get token
    current_user.token = jwt
    current_user.reset_token_at =  Time.now
    current_user.save(validate: false)
    current_user
  end

  def generate_otp_pin(mob_num)
    requested_url = Rails.configuration.SMS[:URI]
    uri = URI.parse(requested_url)
    http = Net::HTTP.start(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    send_sms = Otp.new(mob_num: mob_num, created_at: Time.now, otp_pin: rand(0000..9999).to_s.rjust(4, "0"))
    send_sms.save
    res = Net::HTTP.post_form(uri, 'apikey' => Rails.configuration.SMS[:API_KEY], 'message' => send_sms[:otp_pin], 'numbers' => mob_num, 'test' => true)
    response = JSON.parse(res.body)
    return {balance: response["balance"], otp_pin: response["message"]["content"]} if response["status"] == "success"
    return response
  end

  def user_params
    params.require(:user).permit(:email, :password, :mob_num, :name, :address, :city, :state_code) if params[:user]
  end

  def organisation_params
    params.require(:organisation).permit(:name) if params[:organisation]
  end

  def otp_params
    params.require(:otp).permit(:mob_num, :otp_pin) if params[:otp]
  end

end
