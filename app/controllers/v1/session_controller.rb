class V1::SessionController < ApplicationController

  before_action :authenticate, :only => [:ifSessionExist]

  def ifSessionExist
    if authenticate
      helper = Helper.new
      user = User.find_by(id: params[:uid])
      render json: helper.returnCurrentUser(user: user), status: Helper::HTTP_CODE[:SUCCESS]
    else
      render json: Helper::ACCESS_DENIED, status: Helper::HTTP_CODE[:UNAUTHORIZE]
    end
  end

  def signUp
    helper = Helper.new
    if signUp_params
      user = User.new(signUp_params)
      if user.valid?
        user.save()
        user = generateToken(currentUser: user)
        render json: helper.returnSuccessResponse(obj: {user: saveUser}), status: Helper::HTTP_CODE[:SUCCESS]
      else
        render json: helper.returnErrorResponse(errors: user.errors.messages), status: Helper::HTTP_CODE[:SUCCESS]
      end
    else
      render json: Helper::MISSING_ENTRIES, status: Helper::HTTP_CODE[:BAD_REQUEST]
    end
  end

  def loginViaEmail
    helper = Helper.new
    user = User.where(email: auth_params[:email]).first
    if user.valid_password? auth_params[:password]
      user = generateToken(currentUser: user)
      render json: helper.returnSuccessResponse(obj: {user: user}), status: Helper::HTTP_CODE[:SUCCESS]
    else
      render json: Helper::ACCESS_DENIED, status: Helper::HTTP_CODE[:UNAUTHORIZE]
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
