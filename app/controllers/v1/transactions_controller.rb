class V1::TransactionsController < ApplicationController

  before_action :require_user
  #before_action :require_admin_or_organisation_owner

  def index
    results = []
    from_date = Date.parse(params[:from_date]) if params[:from_date].present?
    to_date = Date.parse(params[:to_date]) if params[:to_date].present?
    scope = Transaction.joins(:ledger_heading).where('organisation_id = ?', params[:organisation_id])
    scope = scope.where("txn_date >= ?", from_date) if from_date.present?
    scope = scope.where("txn_date <= ?", to_date) if to_date.present?
    scope = scope.where("ledger_headings.transaction_type = ?", params[:transaction_type]) if params[:transaction_type].present?
    results = scope.map {|t| TransactionSerializer.new(t).serializable_hash} if scope.present?
    render json: {response: results}
  end

  def show
    transaction = Transaction.find(params[:id]) || not_found
    render json: {response: TransactionSerializer.new(transaction).serializable_hash}
  end

  def update
    transaction = Transaction.find(params[:id]) || not_found
    ApplicationRecord.transaction do
      transaction.update_attributes!(transaction_params)
    end
    render json: {response: TransactionSerializer.new(transaction).serializable_hash}
  end

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
