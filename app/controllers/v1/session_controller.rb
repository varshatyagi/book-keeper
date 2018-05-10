class V1::SessionController < ApplicationController

  before_action :authenticate, :only => [:ifSessionExist]

  def ifSessionExist
    if authenticate
      apiResponse = ApiResponse.new
      user = User.find_by(id: params[:uid])
      render json: apiResponse.returnCurrentUser(user: user), status: ApiResponse::HTTP_CODE[:SUCCESS]
    else
      render json: ApiResponse::ACCESS_DENIED, status: ApiResponse::HTTP_CODE[:UNAUTHORIZE]
    end
  end

  def signUp
    apiResponse = ApiResponse.new
    if signUp_params
      user = User.new(signUp_params)
      if user.valid?
        user.save()
        user = generateToken(currentUser: user)
        render json: apiResponse.returnSuccessResponse(obj: {user: saveUser})
      else
        render json: apiResponse.returnErrorResponse(errors: user.errors.messages)
      end
    else
      render json: ApiResponse::MISSING_ENTRIES, status: ApiResponse::HTTP_CODE[:BAD_REQUEST]
    end
  end

  def loginViaEmail
    apiResponse = ApiResponse.new
    user = User.where(email: auth_params[:email]).first
    if user.valid_password? auth_params[:password]
      user = generateToken(currentUser: user)
      render json: apiResponse.returnSuccessResponse(obj: {user: user}), status: ApiResponse::HTTP_CODE[:SUCCESS]
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

    def generateToken(currentUser: user)
      jwt = Auth.encode({user: currentUser.id}) # get token
      currentUser.update_attributes(token: jwt, reset_token_at: Time.now)
      currentUser
    end

end
