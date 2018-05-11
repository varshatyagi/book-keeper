class V1::OrganisationController < ApplicationController

  def getOrganisationMoneyBalance
    helper = Helper.new
    consolidatedBalance = OrgBalance.find_by(org_id: params[:orgId])
    unless consolidatedBalance
      render json: helper.returnErrorResponse(errors: nil), status: Helper::HTTP_CODE[:BAD_REQUEST]
      return true
    end
    render json: helper.returnSuccessResponse(obj: consolidatedBalance)
  end
end
