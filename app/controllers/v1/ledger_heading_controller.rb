class V1::LedgerHeadingController < ApplicationController

  before_action :authenticate

  def getLedgerHeadings
    helper = Helper.new
    ledgerheadings = nil
    if params[:transaction_type] == nil
      render json: helper.returnSuccessResponse(obj: prepareLedgerHeadings), status: Helper::HTTP_CODE[:SUCCESS]
      return true
    end
    render json: helper.returnSuccessResponse(obj: prepareLedgerHeadingsByType({transcation_type: params[:transaction_type]})), status: Helper::HTTP_CODE[:SUCCESS]
  end

  private

    def prepareLedgerHeadings
      revenueCreditHeadings = prepareLedgerHeadingsByType({transcation_type: "credit", revenue: true})
      revenueDebitHeadings = prepareLedgerHeadingsByType({transcation_type: "debit", revenue: true})

      assetCreditHeadings = prepareLedgerHeadingsByType({transcation_type: "credit", asset: true})
      assetDebitHeadings = prepareLedgerHeadingsByType({transcation_type: "debit", asset: true})

      ledgerHeadingObj = {
        revenue: {credit: revenueCreditHeadings, debit: revenueDebitHeadings},
        asset: {credit: assetCreditHeadings, debit: assetDebitHeadings}
      }
      ledgerHeadingObj
    end

    def prepareLedgerHeadingsByType(paramsHash)
      ledgerRevenueArray = Array.new
      ledgerAssetArray = Array.new
      ledgerheadings = LedgerHeading.where(paramsHash)
      ledgerheadings.all.each do |ledgerHeading|
        if ledgerHeading.revenue === true
          ledgerHeading = ledgerHeading.as_json
          ledgerRevenueArray << ledgerHeading
        else
          ledgerHeading = ledgerHeading.as_json
          ledgerAssetArray << ledgerHeading
        end
      end
      ledgerHeadingObj = {revenue: ledgerRevenueArray, asset: ledgerAssetArray}
      ledgerHeadingObj
    end
end
