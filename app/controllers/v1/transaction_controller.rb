class V1::TransactionController < ApplicationController

  def money_transaction
    # if transaction_params ?
    #   render json: {error: true}
    # end
    # render json: {error: false}
  end

  private
    def transaction_params
      params.require(:transaction).permit(:ledgerHeading, :amount, :remark, :mode)
    end
end
