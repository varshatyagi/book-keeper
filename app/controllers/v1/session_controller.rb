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
        hasUserObj = createOrganisationForUser(user)
        unless hasUserObj
          render json: Helper::UNIQUE_ORG_NAME, status: Helper::HTTP_CODE[:SUCCESS]
          return true
        end
        render json: helper.returnSuccessResponse(obj: {user: generateToken(hasUserObj)}), status: Helper::HTTP_CODE[:SUCCESS]
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
      render json: helper.returnSuccessResponse(obj: {user: generateToken(user)}), status: Helper::HTTP_CODE[:SUCCESS]
    else
      render json: Helper::ACCESS_DENIED, status: Helper::HTTP_CODE[:UNAUTHORIZE]
    end
  end

  def createOrganisationForUser(user)
    helper = Helper.new
    if organisationParams && organisationParams[:name] != nil
      isOrganisationExist = Organisation.find_by(name: organisationParams[:name])
      if isOrganisationExist
        return false
      end
      user.save
      organisation = {created_by: user.id, user_id: user.id, name: organisationParams[:name]}
      org = Organisation.create(organisation)
      unless org
        return false
      end
      OrgBalance.create({
          org_id: org.id,
          cash_opening_balance: 0.0,
          bank_opening_balance: 0.0,
          credit_opening_balance: 0.0,
          financial_year_start: Time.now,
          cash_balance: 0.0,
          bank_balance: 0.0,
          credit_balance: 0.0
        })
      user[:org_id] = org.id
      user.save
      user
    end
  end

  def loginViaOTP
    # use twilio
  end


  def logout
  end

  private
    def authParams
      params.require(:user).permit(:email, :password)
    end

    def signUpParams
      params.require(:user).permit(:email, :password, :mob_num, :name)
    end

    def organisationParams
      params.require(:organisation).permit(:name)
    end

    def generateToken(currentUser)
      jwt = Auth.encode({user: currentUser.id}) # get token
      currentUser.update_attributes(token: jwt, reset_token_at: Time.now)
      currentUser
    end

end
