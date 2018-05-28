class V1::OrganisationsController < ApplicationController

  before_action :require_user
  # before_action :require_admin_or_organisation_owner

  def index
    oraganisations = Organisation.all
    oraganisations = oraganisations.map {|oraganisation| OrganisationSerializer.new(oraganisation).serializable_hash} if oraganisations.present?
    render json: {response: oraganisations}
  end

  def show
    oraganisation = Organisation.find(params[:id]) || not_found
    oraganisation = OrganisationSerializer.new(oraganisation).serializable_hash
    render json: {response: oraganisation}
  end

  def balance_summary
    org_balance_rec = OrgBalance.find_by(organisation_id: params[:id])
    return render json: {errors: ['Balanace Summary is not available for this orgnanisation']}, status: 400 if org_balance_rec.blank?
    render json: {response: OrgBalanceSerializer.new(org_balance_rec).serializable_hash}
  end

  def update
    render json: {errors: ['Required params are missing']}, status: 400 unless organisation_params.present?
    organisation = Organisation.find(params[:id]) || not_found
    ApplicationRecord.transaction do
      organisation.update_attributes!(organisation_params)
    end
    render json: {response: true}, status: 200
  end

  private

  def organisation_params
    params.require(:organisation).permit(:name, org_bank_accounts_attributes: [:id, :bank_id, :account_num, :bank_balance, :initial_balance, :organisation_id])
  end
end
