class ApplicationController < ActionController::API
  require 'auth'
  require 'common'
  require 'uri'

  #before_action :ensure_domain
  @current_user = nil

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: {errors: ['Record not found']}, status: 400
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: {errors: ['Record is Invalid']}, status: 400
  end

  rescue_from RuntimeError do |e|
    render json: {errors: [e.message]}, status: 400
  end

  def require_user
    return true if valid_token?
    render json: {errors: ['You are not authorized to access this resources']}, status: 401
  end

  def require_admin
    return render json: {errors: ['You are not authorized to access this resource']} unless @current_user.role == User::USER_ROLE_ADMIN
    true
  end

  def get_current_user
    @current_user
  end

  def set_current_user(user)
    @current_user = user
  end

  def require_admin_or_organisation_owner
    return render json: {errors: ['Organisation is missing']} unless params[:organisation_id].present?
    organisation = Organisation.find(params[:organisation_id])
    return true if organisation.role == User::USER_ROLE_ADMIN || organisation.owner_id == @current_user[:id]
    render json: {errors: ['You are not authorized to access this resources']}
  end

  def plan_expired
    organisation = Organisation.find(params[:organisation_id])
    plan = organisation.plan
    if plan.plan_end_date < DateTime.now
      return render json: {errors: ['Your plan has been expired. Please contact Onacc admin to renew it.']}, status: 400
    end
    true
  end

  private

  def valid_token?
    token = http_auth_header
    if token.present?
      user = User.find_by(token: token)
      if user.present?
        return false if user.token_expired?
        set_current_user(user)
        return true
      end
    end
    false
  end

  def http_auth_header
    auth_header = request.env.fetch("HTTP_AUTHORIZATION")
    return nil if auth_header.blank?
    auth_header.split(" ").last
  end

  def ensure_domain
    request_host = request.env['HTTP_HOST']
    allowed_hosts = Rails.configuration.allowed_hosts || []
    default_host = Rails.configuration.host

    return if default_host.blank?
    return if default_host == request_host || allowed_hosts.include?(request_host)

    redirect_url = "https://#{default_host}#{request.fullpath}"
    redirect_to redirect_url, status: :moved_permanently
  end
end
