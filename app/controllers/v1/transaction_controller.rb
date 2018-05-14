class V1::TransactionController < ApplicationController

  before_action :authenticate
  def saveTransaction
    helper = Helper.new
    if transactionParams
      # ledgerHeading = LedgerHeading.find_by(params[:ledgerHeading])
      options = {
        ledger_heading_id: transactionParams[:ledgerHeading],
        amount: transactionParams[:amount],
        remarks: transactionParams[:remarks],
        payment_mode: transactionParams[:mode],
        txn_date: transactionParams[:date],
        status: Helper::STATUS[:COMPLETED],
        created_by: params[:uid]
        }
      transactionParams[:mode] == "bank" ? (options[:bank_id] = transactionParams[:bank_id]) : options
      transaction = Transaction.new(options)
      transaction.save()
      render json: helper.returnSuccessResponse(obj: nil), status: Helper::HTTP_CODE[:SUCCESS]
      return
    end
    render json: helper.returnSuccessResponse(errors: nil), status: Helper::HTTP_CODE[:BAD_REQUEST]
  end

  private
    def transactionParams
      params.required(:transaction).permit(:ledgerHeading, :amount, :remarks, :mode, :date)
    end
end
