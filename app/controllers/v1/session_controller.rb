class V1::SessionController < ApplicationController

  def signIn
    #check for email, mobile no validation
  end

  def loginViaEmail
    apiResponse = ApiResponse.new
    user = User.where(email: auth_params[:email]).first
    if user.valid_password?(auth_params[:password])
      jwt = Auth.encode({user: user.id}) # get token
      user.update(token: jwt, reset_password_token_at: Time.now)
      user[:token] = jwt; # save token for future reference
      render json: apiResponse.returnCurrentUser(user: user)
    else
      render json: ApiResponse::ACCESS_DENIED, status: ApiResponse::HTTP_CODE[:UNAUTHORIZE]
    end
  end

  def logout
  end

  private
    def auth_params
      params.require(:session).permit(:email, :password)
    end

end
