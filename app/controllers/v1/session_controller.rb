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
    if signUpParams
      user = User.new(signUpParams)
      if user.valid?
        user.save()
        user = generateToken(currentUser: user)
        render json: helper.returnSuccessResponse(obj: {user: user}), status: Helper::HTTP_CODE[:SUCCESS]
      else
        render json: helper.returnErrorResponse(errors: user.errors.messages), status: Helper::HTTP_CODE[:SUCCESS]
      end
    else
      render json: Helper::MISSING_ENTRIES, status: Helper::HTTP_CODE[:BAD_REQUEST]
    end
  end

  def loginViaEmail
    helper = Helper.new
    user = User.where(email: authParams[:email]).first
    if user.valid_password? authParams[:password]
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
    def authParams
      params.require(:session).permit(:email, :password)
    end

    def signUpParams
      params.require(:session).permit(:email, :password, :mob_num, :name)
    end

    def generateToken(currentUser: user)
      jwt = Auth.encode({user: currentUser.id}) # get token
      currentUser.update_attributes(token: jwt, reset_token_at: Time.now)
      currentUser
    end

end
