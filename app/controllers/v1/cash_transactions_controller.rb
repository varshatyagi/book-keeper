class V1::CashTransactionsController < ApplicationController

  def create
    return render json: {errors: ['Required parameter is missing']} unless cash_transactions_params.present?
    ApplicationRecord.transaction do
      unless params[:type] == "withdrawal" || params[:type] == "deposite"
        return render json: {errors: ['Transaction is not valid']}, status: 400
      end
      cash_transaction = CashTransaction.new(cash_transactions_params)
      cash_transaction.withdrawal = true
      cash_transaction.withdrawal = false unless params[:type] == "withdrawal"
      cash_transaction.txn_date = Time.now unless cash_transactions_params[:txn_date].present?
      cash_transaction.organisation_id = params[:organisation_id]
      cash_transaction.save!
    end
  end

  private
  def cash_transactions_params
    params.require(:cash_transaction).permit(:org_bank_account_id, :amount, :txn_date, :remarks) if params[:cash_transaction]
  end
end
