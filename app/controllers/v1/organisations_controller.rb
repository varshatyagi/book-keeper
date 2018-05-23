class V1::OrganisationsController < ApplicationController

  before_action :require_user
  before_action :require_admin_or_organisation_owner

  def index
    oraganisations = Organisation.all
    oraganisations = oraganisations.map {|oraganisation| OrganisationSerializer.new(oraganisation).serializable_hash} if oraganisations.present?
    render json: {response: oraganisations}
  end

  def show
    oraganisation = Organisation.find(params[:id])
    return render json: {errors: ['Organisation is missing']} unless oraganisation.present?
    oraganisation = OrganisationSerializer.new(oraganisation).serializable_hash if oraganisation.present?
    render json: {response: oraganisation}
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
    errors = []
    bank_obj = nil
      ApplicationRecord.transaction do
        organisation = Organisation.find(params[:id])
        organisation[:name] = org_params[:name]
        if organisation.new_record?
          organisation.save! if organisation.valid?
        end
        opening_balance = bank_record(bank_params, params[:id]) if bank_params.present?
        ApplicationRecord.transaction do
          org_balance_rec = OrgBalance.find(params[:id])
          if org_balance_rec.present?
            org_balance = org_balance_rec.update_attributes!({
              bank_opening_balance: opening_balance,
              financial_year_start: org_params[:financial_year],
              bank_balance: opening_balance
            })
          else
            organisation.update_org_balance_with_opening_balance(opening_balance, params, org_params)
          end
        end
      end
    render json: {response: true}, status: 200
  end

  def bank_record(bank_params, org_id)
    opening_balance = 0
    errors = []
    bank_params.each do |bank|
      ApplicationRecord.transaction do
        org_bank_acc = OrgBankAccount.find_by(bank_id: bank[:bank_id], account_num: bank[:account_number])
        org_bank_acc.update_attributes!({bank_balance: bank[:balance]}) if org_bank_acc.present?
        if org_bank_acc.blank?
          org_bank = OrgBankAccount.new({
            organisation_id: params[:id], bank_id: bank[:bank_id],
            account_num: bank[:account_number], deleted: false, bank_balance: bank[:balance]})
          org_bank.save!
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
