class V1::SessionController < ApplicationController

  before_action :authenticate, :except => [:signUp]

  def signUp
    apiResponse = ApiResponse.new
    if signUp_params
      user = User.new(signUp_params)
      if user.valid?
        user.save()
        saveUser = User.find(user.id)
        render json: apiResponse.returnCurrentUser(user: saveUser)
      else
        render json: apiResponse.returnValidationErrors(errors: user.errors.messages)
      end
    else
      render json: ApiResponse::MISSING_ENTRIES, status: ApiResponse::HTTP_CODE[:BAD_REQUEST]
    end
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

  def loginViaOTP
    # use twilio
  end

  def logout
  end

  private
    def auth_params
      params.require(:session).permit(:email, :password)
    end
    def signUp_params
      params.require(:session).permit(:email, :password, :mob_num, :name)
    end

end
