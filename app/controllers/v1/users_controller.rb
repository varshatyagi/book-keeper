class V1::UsersController < ApplicationController

  require "rubygems"
  require "net/https"
  require "uri"
  require "json"

  def signup
    user = nil
    if signup_params[:mob_num].present?
      user = User.find_by(mob_num: signup_params[:mob_num])
    elsif signup_params[:email].present?
      user = User.find_by(email: signup_params[:email])
    end
    if user.present?
      return render json: {response: ['Thank you. Admin will contact you for further communication.']}
    end
    ApplicationRecord.transaction do
      user = User.new(signup_params)
      user.role = User::USER_ROLE_CLIENT
      user.status = User::USER_STATUS_PENDING
      user.save
      organisation = Organisation.find(user.organisations.collect(&:id)[0])
      organisation.update_attributes!(owner_id: user.id, is_setup_complete: false)
      user.update_attributes!(organisation_id: organisation.id)
    end
    # TODO do alternate things for email and messages
    render json: {response: UserSerializer.new(user).serializable_hash}, status: 200
  end

  def show
    raise 'User is not found' unless User.find_by(id: params[:id]).present?
    user = User.find(params[:id])
    render json: {response: {user: UserSerializer.new(user).serializable_hash}}, status: 200
  end

  def update
    raise 'Requested Uesr is not found' unless User.find_by(id: params[:id]).present?
    user = User.find_by(id: params[:id])
    user = user.update_attributes!(user_params)
    render json: {response: user}
  end

  def login
    if otp_params.present?
      has_user_obj = login_via_otp(otp_params)
      return render json: has_user_obj, status: 401 if has_user_obj.kind_of?(Hash) && has_user_obj[:errors].present?
      return render json: has_user_obj
    elsif user_params.present?
      has_user_obj = login_via_email(user_params)
      return render json: has_user_obj, status: 401 if has_user_obj.kind_of?(Hash) && has_user_obj[:errors].present?
      return render json: has_user_obj
    else
      render json: {errors: ['Your are not authorized to access this resource']}, status: 401
    end
  end

  def login_via_email(options)
    raise 'User is not registered with provided email id' unless User.find_by(email: options[:email])
    user = User.find_by(email: options[:email])
    return {errors: ['password is not valid']} unless user.present? && (user.valid_password? options[:password])
    generate_token(user)
    return {response: {user: UserSerializer.new(user).serializable_hash}}
  end

  def login_via_otp(otp_params)
    raise 'Mobile Number and OTP combination is invalid' unless Otp.find_by(mob_num: otp_params[:mob_num], otp_pin: otp_params[:otp_pin])
    otp_record = Otp.find_by(mob_num: otp_params[:mob_num])
    return {errors: ['OTP has been expired']} unless otp_record.present? && (Time.now.to_i - otp_record.created_at.to_i) < Otp::OTP_EXPIRATION_TIME
    register_user_via_otp_login(otp_params) unless User.find_by(mob_num: otp_params[:mob_num])
    user = User.find_by(mob_num: otp_params[:mob_num])
    otp_record.destroy
    generate_token(user)
    return {response: {user: UserSerializer.new(user).serializable_hash}}
  end

  def otp
    return render json: {errors: ['Mobile number is not registered']}, status: 400 if otp_params[:mob_num].blank?
    otp_record = Otp.find_by(mob_num: otp_params[:mob_num])
    is_expired = false
    if otp_record.present?
      is_expired = (Time.now.to_i - otp_record.created_at.to_i) > Otp::OTP_EXPIRATION_TIME
    end
    if is_expired
      otp_record.destroy
    end

    if !is_expired && otp_record.present?
      otp_pin = otp_record.otp_pin
    else
      otp_pin = generate_otp_pin(otp_params[:mob_num])
    end
    render json: {response: {otp_pin: otp_pin}}
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
    return response["message"]["content"] if response["status"] == "success"
    return response
  end

  def register_user_via_otp_login(otp_params)
    user = User.new(mob_num: otp_params[:mob_num])
    raise 'Mobile Number is already register' unless user.valid?
    if organisation_params.present?
      organisation = Organisation.new(organisation_params)
      organisation.valid?
    end
    organisation = Organisation.create
    organisation.owner_id = user.id
    organisation.save
    user.organisation_id = organisation.id
    user.save
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

  def signup_params
    params.require(:user).permit(:mob_num, :email, :organisation_id, organisations_attributes: [:id, :preferred_plan_id]) if params[:user]
  end

end
