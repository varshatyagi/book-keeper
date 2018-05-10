class V1::LedgerHeadingController < ApplicationController

  before_action :authenticate

  def getLedgerHeadings
    apiResponse = ApiResponse.new
    ledgerheadings = nil
    if params[:type] == nil
      render json: apiResponse.returnSuccessResponse(obj: prepareLedgerHeadings)
      return true
    end
    paramsHash = Hash.new
    paramsHash[params[:type]] = true
    render json: apiResponse.returnSuccessResponse(obj: {params[:type] => prepareLedgerHeadingsByType(paramsHash)})
  end

  private

    def prepareLedgerHeadings
      assetHeadings = prepareLedgerHeadingsByType({asset: true})
      revenueHeadings = prepareLedgerHeadingsByType({revenue: true})
      ledgerHeadingObj = {revenue: revenueHeadings, asset: assetHeadings}
      ledgerHeadingObj
    end

    def prepareLedgerHeadingsByType(paramsHash)
      ledgerCreditArray = Array.new
      ledgerDebitArray = Array.new
      ledgerheadings = LedgerHeading.where(paramsHash)
      ledgerheadings.all.each do |ledgerHeading|
        if ledgerHeading.transcation_type === "credit"
          ledgerHeading = ledgerHeading.as_json
          ledgerCreditArray << ledgerHeading
        else
          ledgerHeading = ledgerHeading.as_json
          ledgerDebitArray << ledgerHeading
        end
      end
      ledgerHeadingObj = {credit: ledgerCreditArray, debit: ledgerDebitArray}
      ledgerHeadingObj
    end
end
