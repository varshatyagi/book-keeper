class V1::UtilityController < ApplicationController

  def getBankList
    helper = Helper.new
    banks = Bank.all
    render json: helper.returnSuccessResponse(obj: banks)
  end
end
