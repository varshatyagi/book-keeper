class V1::SessionController < ApplicationController
  def create
    apiResponse = ApiResponse.new
    user = User.where(email: params[:email]).first
    if user.valid_password?(params[:password])
      render json: apiResponse.returnCurrentUser(user: user)
    else
      render json: ApiResponse::ACCESS_DENIED, status: ApiResponse::HTTP_CODE[:UNAUTHORIZE]
    end
  end

  def logout
  end

end
