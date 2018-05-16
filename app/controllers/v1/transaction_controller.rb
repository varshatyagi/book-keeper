class V1::TransactionController < ApplicationController

  before_action :authenticate
  def saveTransaction
    if transactionParams
      ledgerHeading = LedgerHeading.find_by({id: transactionParams[:ledgerHeading]})
      options = {
        ledger_heading_id: transactionParams[:ledgerHeading],
        amount: transactionParams[:amount],
        remarks: transactionParams[:remarks],
        payment_mode: transactionParams[:mode],
        txn_date: transactionParams[:date],
        status: Helper::STATUS[:COMPLETED],
        created_by: params[:uid]
        }
      if transactionParams[:mode] != "bank"
        createTransaction(options)
        return
      end
      options[:org_bank_account_id] = transactionParams[:bank_id]
      accountNumber = transactionParams[:accountNumber]
      begin
        ApplicationRecord.transaction do
          transaction = Transaction.new(options)
          transaction.save!
          ApplicationRecord.transaction do
            user = User.find_by(id: params[:uid])
            orgBankAccount = OrgBankAccount.find_by(bank_id: options[:org_bank_account_id], org_id: user.org_id, account_num: accountNumber).first
            (ledgerHeading[:transaction_type] == 'credit') ? orgBankBalance = orgBankAccount[:bank_balance] + options[:amount] : orgBankBalance = orgBankAccount[:bank_balance] - options[:amount]
            orgBankAccount.update_attributes!({bank_balance: orgBankBalance})
            byebug
            ApplicationRecord.transaction do
              orgBalanceObj = OrgBalance.find_by({org_id: user.org_id})
              orgBalance = orgBalanceObj[:bank_balance] - options[:amount]
              orgBalanceObj.update_attributes!({bank_balance: orgBalance})
            end
          end
        end
      rescue StandardError => error
        render json: {errors: error, status: false, response: nil}, status: Helper::HTTP_CODE[:BAD_REQUEST]
        return
      end
      render json: Helper::STANDARD_RESPONSE, status: Helper::HTTP_CODE[:SUCCESS]
      return
    end
    render json: Helper::STANDARD_ERROR, status: Helper::HTTP_CODE[:BAD_REQUEST]
  end

  def createTransaction(options)
    transaction = Transaction.new(options)
    if transaction.valid?
      render json: Helper::STANDARD_RESPONSE, status: Helper::HTTP_CODE[:SUCCESS]
      return
    end
    render json: {errors: transaction.errors.messages, status: false, response: nil}, status: Helper::HTTP_CODE[:BAD_REQUEST]
    return
  end

  private
    def transactionParams
      params.required(:transaction).permit(:ledgerHeading, :amount, :remarks, :mode, :date, :bank_id, :accountNumber)
    end
end
