class V1::TransactionsController < ApplicationController

  before_action :require_user
  before_action :require_admin_or_organisation_owner

  def create
    if transaction_params
      options = transaction_params
      options[:status] = Common::STATUS[:COMPLETED]
      options[:created_by] = @current_user[:id]
      options[:txn_date] = Time.now unless transaction_params[:txn_date].present?
      options[:organisation_id] = params[:organisation_id]
      ApplicationRecord.transaction do
        transaction = Transaction.new(options)
        transaction.save!
        render json: {response: true}
      end
    end
  end

  private
    def transaction_params
      params.required(:transaction).permit(:ledger_heading_id, :amount, :remarks, :payment_mode, :txn_date, :org_bank_account_id)
    end
end
