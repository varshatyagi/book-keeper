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
        txn_date: Time.now,
        status: 'completed',
        created_by: params[:uid]
        }
      transactionParams[:mode] == "bank" ? (options[:bank_id] = transactionParams[:org_bank_account]) : options
      transaction = Transaction.new(options)
      transaction.save()
      Rails.logger.info(transaction.errors.messages.inspect)
      byebug
      render json: helper.returnSuccessResponse
      return
    end
    render json: helper.returnErrorResponse
  end

  private
    def transactionParams
      params.required(:transaction).permit(:ledgerHeading, :amount, :remarks, :mode)
    end
end
