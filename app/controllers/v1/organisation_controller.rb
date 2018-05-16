class V1::OrganisationController < ApplicationController

  before_action :authenticate

  def getOrganisationMoneyBalance
    consolidatedBalance = OrgBalance.find_by(org_id: params[:orgId])
    unless consolidatedBalance
      render json: Helper::STANDARD_ERROR, status: Helper::HTTP_CODE[:BAD_REQUEST]
      return true
    end
    render json: {errors: nil, status: true, response: consolidatedBalance}, status: Helper::HTTP_CODE[:SUCCESS]
  end

  def organisation
    organisation = Organisation.find_by(id: params[:orgId])
    unless organisation
      render json: {errors: error, status: false, response: nil}, status: Helper::HTTP_CODE[:BAD_REQUEST]
      return true
    end
    render json: {errors: nil, status: true, response: organisation}, status: Helper::HTTP_CODE[:SUCCESS]
  end

  def update
    openingBalance = 0
    unless orgParams
      render json: Helper::STANDARD_RESPONSE, status: Helper::HTTP_CODE[:BAD_REQUEST]
    end
    begin
      ApplicationRecord.transaction do
        organisation = Organisation.find_by!(id: params[:orgId])
        organisation.update_attributes!({name: orgParams[:name]})
        if bankParams
          bankParams.each do |bank|
            ApplicationRecord.transaction do
              ifOrgBankExist = OrgBankAccount.find_by!(org_id: params[:orgId], bank_id: bank[:bankId])
              if ifOrgBankExist
                orgBank = ifOrgBankExist.update_attributes!({bank_balance: bank[:balance], account_num: bank[:accountNumber]})
              else
                orgBank = OrgBankAccount.new({
                  org_id: params[:orgId],
                  bank_id: bank[:bankId],
                  account_num: bank[:accountNumber],
                  deleted: false,
                  bank_balance: bank[:balance]
                })
                orgBank.save!
              end
            end
            openingBalance += bank[:balance]
          end
        end
        ApplicationRecord.transaction do
        ifOrgBalanceExist = OrgBalance.find_by!({org_id: params[:orgId]})
          if ifOrgBalanceExist
            orgBalance = ifOrgBalanceExist.update_attributes!({
              bank_opening_balance: openingBalance,
              financial_year_start: orgParams[:financialYear],
              bank_balance: openingBalance
            })
          else
              orgBalance = OrgBalance.new({
                org_id: params[:orgId],
                cash_opening_balance: 0,
                bank_opening_balance: openingBalance,
                credit_opening_balance: 0,
                financial_year_start: orgParams[:financialYear],
                cash_balance: 0,
                bank_balance: openingBalance,
                credit_balance: 0
              })
              orgBalance.save!
          end
        end
      end
    rescue StandardError => error
      render json: {errors: error, status: false, response: nil}, status: Helper::HTTP_CODE[:BAD_REQUEST]
      return
    end
    render json: Helper::STANDARD_RESPONSE, status: Helper::HTTP_CODE[:SUCCESS]
  end

  private
    def orgParams
      params.required(:organisation).permit(:name)
    end
    def orgBalanceParams
      params.required(:org_balance).permit(:financialYear)
    end
    def bankParams
      params.require(:org_bank_accounts).map { |m| m.require(:bank).permit(:bankId, :balance, :accountNumber)}
    end
end
