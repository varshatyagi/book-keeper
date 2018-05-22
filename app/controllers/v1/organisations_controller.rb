class V1::OrganisationsController < ApplicationController

  before_action :require_user

  def index
    oraganisations = Organisation.all
    oraganisations = oraganisations.map {|oraganisation| OrganisationSerializer.new(oraganisation).serializable_hash} if banks.present?
    render json: {response: oraganisations}
  end

  def show
    oraganisations = Organisation.find(:id)
    return render json: {errors: ['Oranisation is missing']} unless oraganisations.present?
    oraganisations = oraganisations.map {|oraganisation| OrganisationSerializer.new(oraganisation).serializable_hash} if banks.present?
    render json: {response: oraganisations}
  end

  def balance_summary
    org_balance_rec = OrgBalance.find_by(organisation_id: params[:id])
    return render json: {errors: ['Balanace Summary is not available for this orgnanisation']} if org_balance_rec.blank?
    org_balance_rec = org_balance_rec.map {|org_balance| OrgBalanceSerializer.new(org_balance).serializable_hash} if org_balance_rec.present?
    render json: {response: org_balance_rec}
  end

  def org_bank_accounts
    org_bank_accnts = OrgBankAccount.where({organisation_id: params[:id]})
    return render json: {error: ['Banks accounts are not available for this Organisation']} if org_bank_accnts.blank?
    render json: {response: org_bank_accnts}

  end

  def update
    render json: {errors: ['Required params are missing']}, status: 400 unless org_params.present?
    begin
      ApplicationRecord.transaction do
        organisation = Organisation.find!(params[:id])
        organisation.update_attributes!({name: org_params[:name]})
        opening_balance = bank_record(bank_params, params[:id]) if bank_params.present?
        ApplicationRecord.transaction do
          org_balance_rec = OrgBalance.find(params[:id])
          if org_balance_rec.present?
            orgBalance = org_balance_rec.update_attributes!({
              bank_opening_balance: opening_balance,
              financial_year_start: org_params[:financial_year],
              bank_balance: opening_balance
            })
          else
              orgBalance = OrgBalance.new({
                organisation_id: params[:id],
                cash_opening_balance: 0,
                bank_opening_balance: opening_balance,
                credit_opening_balance: 0,
                financial_year_start: org_params[:financial_year],
                cash_balance: 0,
                bank_balance: opening_balance,
                credit_balance: 0
              })
              orgBalance.save!
          end
        end
      end
    rescue StandardError => error
      render json: {errors: [error]}, status: 404
      return
    end
    render json: {}, status: 404
  end

  def bank_record(bank_params, org_id)
    opening_balance = 0
    bank_params.each do |bank|
      ApplicationRecord.transaction do
        org_bank_acc = OrgBankAccount.find_by(organisation_id: org_id)
        org_bank_acc.update_attributes!({bank_balance: bank[:balance], account_num: bank[:accountNumber]}) if org_bank_acc.present?
        if org_bank_acc.blank?
          orgBank = OrgBankAccount.new({
            organisation_id: params[:org_id], bank_id: bank[:bank_id],
            account_num: bank[:account_number], deleted: false, bank_balance: bank[:balance]})
          orgBank.save!
        end
      end
      opening_balance += bank[:balance]
    end
    opening_balance
  end

  private
    def org_params
      params.required(:organisation).permit(:name)
    end
    def org_balance_params
      params.required(:org_balance).permit(:financial_year)
    end
    def bank_params
      params.require(:org_bank_accounts).map { |m| m.require(:bank).permit(:bank_id, :balance, :account_number)}
    end
end
