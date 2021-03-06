class V1::CashTransactionsController < ApplicationController

  before_action :require_user
  before_action :plan_expired
  before_action :require_admin_or_organisation_owner

  def create
    ApplicationRecord.transaction do
      unless params[:type].upcase == CashTransaction::WITHDRAWAL || params[:type].upcase == CashTransaction::DEPOSIT
        return render json: {errors: ['Transaction is not valid']}, status: 400
      end
      cash_transaction = CashTransaction.new(cash_transactions_params)

      if params[:type].upcase == CashTransaction::WITHDRAWAL
        cash_transaction.withdrawal = true
        ledger_id = LedgerHeading.find_by(name: CashTransaction::WITHDRAWAL).id
        cash_transaction.ledger_heading_id = ledger_id
      else
        cash_transaction.withdrawal = false
        ledger_id = LedgerHeading.find_by(name: CashTransaction::DEPOSIT).id
        cash_transaction.ledger_heading_id = ledger_id
      end
      cash_transaction.txn_date = Time.now unless cash_transactions_params[:txn_date].present?
      cash_transaction.organisation_id = params[:organisation_id]
      cash_transaction.save!
      render json: {response: CashTransactionSerializer.new(cash_transaction).serializable_hash}
    end
  end

  private
  def cash_transactions_params
    params.require(:cash_transaction).permit(:org_bank_account_id, :amount, :txn_date, :remarks, :organisation_id) if params[:cash_transaction]
  end
end
