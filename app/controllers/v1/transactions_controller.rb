class V1::TransactionsController < ApplicationController

  before_action :require_user
  # before_action :require_admin_or_organisation_owner

  def create
    ApplicationRecord.transaction do
      transaction = Transaction.new(transaction_params)
      transaction.status = Transaction::STATUS[:COMPLETED]
      transaction.created_by = @current_user[:id]
      transaction.txn_date = Time.now unless transaction_params[:txn_date].present?
      transaction.organisation_id = params[:organisation_id]
      transaction.save!
      render json: {response: true}
    end
  end

  private
  def transaction_params
    params.require(:transaction).permit(:ledger_heading_id, :amount, :remarks, :payment_mode, :txn_date, :org_bank_account_id, :alliance_id)
  end
end
