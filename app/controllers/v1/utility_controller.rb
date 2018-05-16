class V1::UtilityController < ApplicationController

  def getBankList
    banks = Bank.all
    render json: {errors: nil, status: true, response: {banks: banks}}, status: Helper::HTTP_CODE[:SUCCESS]
  end
end
