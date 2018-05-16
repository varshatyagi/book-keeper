class V1::SessionController < ApplicationController

  def signUp
    if signUpParams
      user = User.new(signUpParams)
      if user.valid?
        begin
          ApplicationRecord.transaction do
            organisation = Organisation.new(name: organisationParams[:name])
            organisation.save!
            ApplicationRecord.transaction do
              user[:org_id] = organisation.id
              user.save!
              ApplicationRecord.transaction do
                organisation.update_attributes!({created_by: user.id, user_id: user.id})
              end
            end
          end
        rescue StandardError => error
          render json: {errors: error, status: false, response: nil}, status: Helper::HTTP_CODE[:BAD_REQUEST]
          return
        end
        render json: {errors: nil, status: true, response: {user: generateToken(user)}}, status: Helper::HTTP_CODE[:SUCCESS]
      else
        render json: {errors: user.errors.messages, status: false, response: nil}, status: Helper::HTTP_CODE[:BAD_REQUEST]
      end
    else
      render json: Helper::MISSING_ENTRIES, status: Helper.HTTP_CODE[:BAD_REQUEST]
    end
  end

  def loginViaEmail
    user = User.find_by!(email: authParams[:email])
    if user.valid_password? authParams[:password]
      render json: {errors: nil, status: true, response: {user: generateToken(user)}}, status: Helper::HTTP_CODE[:SUCCESS]
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
