class V1::UsersController < ApplicationController

  require "rubygems"
  require "net/https"
  require "uri"
  require "json"

  def signup
    user = nil
    success_msg = "Thank you for showing interest in Onacc. Admin will get back to you at the earliest!"
    need_to_send_sms = false
    if signup_params[:mob_num].present?
      user = User.find_by(mob_num: signup_params[:mob_num])
      need_to_send_sms = true
    elsif signup_params[:email].present?
      user = User.find_by(email: signup_params[:email])
    end
    if user.blank?
      ApplicationRecord.transaction do
        user = User.new(signup_params)
        user.role = User::USER_ROLE_CLIENT
        user.status = User::USER_STATUS_PENDING
        user.save
        organisation = Organisation.find(user.organisation.id)
        organisation.update_attributes!(is_setup_complete: false, created_by: user.id)
        user.update_attributes!(organisation_id: user.organisation.id)
        if need_to_send_sms
          Common.send_sms({message: success_msg, mob_num: user.mob_num})
        else
          OrganizationNotifierMailer.thank_you_email(user).deliver
        end
        OrganizationNotifierMailer.activate_user(user).deliver
      end
    elsif user.organisation.active_plan_id.blank?
      success_msg = "We have already received a request from you. Admin will get back to you at the earliest!"
    end
    render json: {response: [success_msg]}
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
      response = login_via_otp(otp_params)
      return render json: response, status: 401 if response.kind_of?(Hash) && response[:errors].present?
      return render json: response
    elsif user_params.present?
      response = login_via_email(user_params)
      return render json: response, status: 401 if response.kind_of?(Hash) && response[:errors].present?
      return render json: response
    else
      render json: {errors: ['Your are not authorized to access this resource']}, status: 401
    end
  end

  def login_via_email(options)
    user = User.find_by(email: options[:email])
    unless user.present?
      return {errors: ['User is not registered with provided email id']}
    end

    unless user.valid_password? options[:password]
      return {errors: ['password is not valid']}
    end
    user_response = UserSerializer.new(user).serializable_hash
    user_response[:token] = generate_token(user)
    {response: user_response}
  end

  def login_via_otp(otp_params)
    # check for present of otp and its validity
    otp_existing_record = Otp.find_by(mob_num: otp_params[:mob_num], otp_pin: otp_params[:otp_pin])
    unless otp_existing_record.present?
      return {errors: ['Mobile Number and OTP combination is invalid']}
    end
    if (Time.now.to_i - otp_existing_record.created_at.to_i) > Otp::OTP_EXPIRATION_TIME
      return {errors: ['OTP has been expired']}
    end
    # check for present user if it exist
    user = User.find_by(mob_num: otp_params[:mob_num])
    raise 'This mobile number is not register' unless user.present?
    user.is_temporary_password = false
    otp_existing_record.destroy
    user_response = UserSerializer.new(user).serializable_hash
    user_response[:token] = generate_token(user)
    {response: user_response}
  end

  def change_password
    user = User.find(params[:id])
    options = {}
    unless user.present?
      return render json: {errors: ['User is not found']}
    end
    unless user.valid_password? user_params[:old_password]
      return render json: {errors: ['Password is not correct']}
    end
    if user.is_temporary_password
      options[:is_temporary_password] = false
    end
    options[:password] = user_params[:password]
    options[:password_confirmation] = user_params[:password]
    user.update_attributes!(options)
    render json: {response: UserSerializer.new(user).serializable_hash}
  end

  def forgot_password
    if signup_params[:mob_num].present?
      user = User.find_by(mob_num: signup_params[:mob_num])
      need_to_send_sms = true
    elsif signup_params[:email].present?
      user = User.find_by(email: signup_params[:email])
    end
    unless user.present?
      return render json: {errors: ['User is not found']}
    end
    user.is_temporary_password = true
    password = Common.generate_string
    user.update_attributes({password: password, password_confirmation: password})
    url_code = Common.short_url_code(User::FORGOT_PASSWORD_URL)
    message = "Your temporary password is : #{password}. Please click on below link to reset your password #{User::BASE_URL}#{url_code}"
    if need_to_send_sms
      Common.send_sms({message: message, mob_num: user.mob_num})
    else
      OrganizationNotifierMailer.forgot_password(user, password).deliver
    end
    render json: {response: UserSerializer.new(user).serializable_hash}
  end

  def otp
    raise 'Please provide Mobile Number to send otp' unless otp_params[:mob_num].present?
    otp_existing_record = Otp.find_by(mob_num: otp_params[:mob_num])
    if otp_existing_record.present?
      is_expired = (Time.now.to_i - otp_existing_record.created_at.to_i) > Otp::OTP_EXPIRATION_TIME
      if is_expired
        otp_existing_record.destroy
        otp_record = Otp.create(mob_num: otp_params[:mob_num], created_at: Time.now, otp_pin: Common.otp)
        otp_pin = otp_record.otp_pin
      elsif !is_expired && otp_existing_record.present?
        otp_pin = otp_existing_record.otp_pin
      end
    else
      otp_record = Otp.new(mob_num: otp_params[:mob_num], created_at: Time.now, otp_pin: Common.otp)
      msg_response = Common.send_sms({message: otp_record.otp_pin, mob_num: otp_record.mob_num})
      if msg_response["status"] == "failure"
        return render json: {errors: [msg_response["warnings"].first["message"]]} if msg_response["warnings"].present?
        return render json: {errors: [msg_response["errors"].first["message"]]} if msg_response["errors"].present?
      end
      otp_pin = msg_response["message"]["content"]
      otp_record.save!
    end
    render json: {response: {otp_pin: otp_pin}}
  end

  def actual_url
    record = ShortUrl.find_by(url_code: params[:url_code])
    record.destroy
    render json: {response: ShortUrlSerializer.new(record).serializable_hash}
  end

  private

  def generate_token(current_user)
    jwt = Auth.encode({
      user: current_user.id,
      iat: Time.new.strftime('%s'),
      exp: (Time.new + 1.hour).strftime('%s')
    }) # get token
    jwt
  end

  def user_params
    params.require(:user).permit(:email, :password, :mob_num, :name, :address, :city, :state_code, :old_password) if params[:user]
  end

  def otp_params
    params.require(:otp).permit(:mob_num, :otp_pin) if params[:otp]
  end

  def signup_params
    params.require(:user).permit(:mob_num, :email, :organisation_id, organisation_attributes: [:id, :preferred_plan_id]) if params[:user]
  end

end
