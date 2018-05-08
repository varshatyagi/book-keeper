class ApplicationController < ActionController::API
  require 'error_codes'
  require 'auth'

  def authenticate
    auth_present ? true : (render json: ApiResponse::ACCESS_DENIED, status: ApiResponse::HTTP_CODE[:UNAUTHORIZE])
  end

  private
    def auth_present
      if request.env.fetch("HTTP_AUTHORIZATION", "").scan(/Bearer/).flatten.first === 'Bearer'
        checkAuthentication
      else
        return false
      end
    end

    def checkAuthentication
      token = request.env["HTTP_AUTHORIZATION"].scan(/Bearer(.*)$/).flatten.last.squish
      if token && Auth.decode(token)
        decodedUserId = Auth.decode(token)
        currentUser = getCurrentUser(userId: decodedUserId["user"])
        isTokenValid(token: token, user: currentUser)
      else
        return false
      end
    end

    def getCurrentUser(userId: userId)
      return User.find(userId)
    end

    def isTokenValid(token: token, user: currentUser)
      token === user[:token] ? !((DateTime.now.to_i - user[:reset_token_at].to_i) > ApiResponse::TOKEN_EXPIRATION_TIME) : false
    end

end
