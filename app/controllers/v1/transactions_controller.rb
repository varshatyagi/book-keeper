class V1::TransactionsController < ApplicationController

  before_action :require_user
  def saveTransaction
    if transactionParams
      ledgerHeading = LedgerHeading.find_by({id: transactionParams[:ledgerHeading]})
      transactionParams[:status] = Helper::STATUS[:COMPLETED]
      transactionParams[created_by] = params[:uid]
      options = transactionParams

      if transactionParams[:payment_mode] != "bank"
        createTransaction(options, params[:uid], ledgerHeading)
        return
      end
      options[:org_bank_account_id] = transactionParams[:bankId]
      begin
        ApplicationRecord.transaction do
          transaction = Transaction.new(options)
          transaction.save!
          ApplicationRecord.transaction do
            user = User.find_by(id: params[:uid])
            orgBankAccount = OrgBankAccount.find_by(bank_id: options[:org_bank_account_id], org_id: user.org_id)
            if ledgerHeading[:transcation_type] == 'credit'
              orgBankBalance = orgBankAccount[:bank_balance] + options[:amount]
            else
              orgBankBalance = orgBankAccount[:bank_balance] - options[:amount]
            end

            orgBankAccount.update_attributes!({bank_balance: orgBankBalance})
            orgBankAccount.save
            ApplicationRecord.transaction do
              orgBalanceObj = OrgBalance.find_by({org_id: user.org_id})
              if ledgerHeading[:transcation_type] == 'credit'
                orgBalance = orgBalanceObj[:bank_balance] + options[:amount]
              else
                orgBalance = orgBalanceObj[:bank_balance] - options[:amount]
              end
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

  def createTransaction(options, uid, ledgerHeading)
    ApplicationRecord.transaction do
      transaction = Transaction.new(options)
      transaction.save!
      ApplicationRecord.transaction do
        user = User.find_by({id: uid})
        orgBalanceObj = OrgBalance.find_by({org_id: user.org_id})

        case options[:payment_mode]
        when "cash"
          (ledgerHeading[:transcation_type] == 'credit') ? orgBalance = orgBalanceObj[:cash_balance] + options[:amount] : orgBalance = orgBalanceObj[:cash_balance] - options[:amount]
          orgBalanceObj.update_attributes!({cash_balance: orgBalance})
        else
          (ledgerHeading[:transcation_type] == 'credit') ? orgBalance = orgBalanceObj[:credit_balance] + options[:amount] : orgBalance = orgBalanceObj[:credit_balance] - options[:amount]
          orgBalanceObj.update_attributes!({credit_balance: orgBalance})
        end
      end
    end
    render json: Helper::STANDARD_RESPONSE, status: Helper::HTTP_CODE[:SUCCESS]
  end

  private
    def transactionParams
      params.required(:transaction).permit(:ledgerHeading, :amount, :remarks, :payment_mode, :txn_date, :bankId)
    end
end
