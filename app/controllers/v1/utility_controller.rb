class V1::UtilityController < ApplicationController

  def getBankList
    banks = Bank.all
    render json: {errors: nil, status: true, response: banks}, status: Helper::HTTP_CODE[:SUCCESS]
  end

  def getOrganisationBanks
    banks = OrgBankAccount.where({org_id: params[:orgId]})
    render json: {errors: nil, status: true, response: banks}, status: Helper::HTTP_CODE[:SUCCESS]
  end
end
