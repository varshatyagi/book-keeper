class ApplicationController < ActionController::API
  require 'helper'
  require 'auth'
  require 'common'
  require 'uri'

  #before_action :ensure_domain
  @current_user = nil

  rescue_from ActiveRecord::RecordInvalid do |e|
    error = e.record.errors.values.flatten(2)
    error = error[0] if error.kind_of?(Array)
    error = error[:message] if error.kind_of?(Hash)
    render json: {errors: [error]}, status: 422
  end
  
  rescue_from RuntimeError do |e|
    render json: {errors: [e.message]}, status: 400
  end

  def require_user
    return true if valid_token?
    render json: Helper::ACCESS_DENIED, status: 401
  end

  def require_admin
    get_current_user
  end

  def get_current_user
    @current_user
  end

  def set_current_user(user)
    @current_user = user
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
