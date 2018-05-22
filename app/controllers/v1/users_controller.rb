class V1::UsersController < ApplicationController

  require "rubygems"
  require "net/https"
  require "uri"
  require "json"
  # before_action :require_user

  def create
    user_sign_up_via_login = true
    return render json: {errors: ['You are not authorized to access this resource.']} if user_params.blank? || otp_params.blank?
    user_sign_up_via_login = false if otp_params.present?
    user = User.new(user_params)
    organisation = Organisation.new(organisation_params)
    otp = Otp.new({mob_num: otp_params[:mob_num], otp_pin: otp_params[:otp_pin]})
    errors = []
    errors << otp.errors.values unless otp.valid?
    errors << user.errors.values unless user.valid?
    errors << organisation.errors.values unless organisation.valid?
    errors = errors.flatten(3)
    errors = Common.process_errors(errors)
    return render json: {errors: errors}, status: 400 if errors.present?
    ApplicationRecord.transaction do
      unless user_sign_up_via_login
        otp_record = Otp.find_by(mob_num: otp_params[:mob_num])
        return render json:  {errors: ['You are not authorized to access this resource']} unless otp_record.present? && (Time.now.to_i - otp_record.created_at.to_i) < Otp::OTP_EXPIRATION_TIME
        otp_record = Otp.find_by({mob_num: otp_params[:mob_num]})
        otp_record.destroy!
      end
      user.role = User::USER_ROLE_CLIENT
      user.save!
      organisation.user_id = user.id
      organisation.save!
      user.update_attributes({organisation_id: organisation.id})
    end
    generate_token(user)
    render json: {response: {user: UserSerializer.new(user).serializable_hash}}, status: 200
  rescue StandardError => error
    render json: {errors: [error]}, status: 400
  end

  def show
    return render json: {errors: ['User id is not valid']} if params[:id].blank?
    user = User.find(params[:id])
    render json: {response: {user: UserSerializer.new(user).serializable_hash}}, status: 200
  end

  def login
    if otp_params[:mob_num].present? && otp_params[:otp_pin].present?
      render json: login_via_otp(otp_params)
    elsif user_params[:email].present? && user_params[:password].present?
      render json: login_via_email(user_params)
    else
      render json: {errors: ['Your are not authorized to access this resource']}, status: 401
    end
  end

  def login_via_email(options)
    user = User.find_by(email: options[:email])
     return {errors: ['Your are not authorized to access this resource']} unless user.present? && (user.valid_password? options[:password])
     generate_token(user)
     return {response: {user: UserSerializer.new(user).serializable_hash}}
  end

  def login_via_otp(otp_params)
    otp_record = Otp.find_by(mob_num: otp_params[:mob_num])
    return {errors: ['You are not authorized to access this resource']} unless otp_record.present? && (Time.now.to_i - otp_record.created_at.to_i) < Otp::OTP_EXPIRATION_TIME
    user = User.find_by(mob_num: otp_params[:mob_num])
    return {errors: ['Otp is not valid']} if user.blank?
    otp_record.destroy
    generate_token(user)
    return {response: {user: UserSerializer.new(user).serializable_hash}}
  end

  def otp
    return render json: {errors: ['Please enter valid mobile number']} if otp_params[:mob_num].blank?
    otp_record = Otp.find_by({mob_num: otp_params[:mob_num]})
    return render json: {response: {otp: otp_record.otp_pin}} if otp_record.present? && (Time.now.to_i - otp_record.created_at.to_i) < Otp::OTP_EXPIRATION_TIME
    render json: {response: generate_otp_pin(otp_params[:mob_num])}
  end

  private

  def generate_token(current_user)
    jwt = Auth.encode({user: current_user.id}) # get token
    current_user.update_attributes(token: jwt, reset_token_at: Time.now)
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
    params.require(:user).permit(:email, :password, :mob_num, :name)
  end

  def organisation_params
    params.require(:organisation).permit(:name)
  end

  def otp_params
    params.require(:otp).permit(:mob_num, :otp_pin)
  end

end
