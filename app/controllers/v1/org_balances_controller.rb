class V1::OrgBalancesController < ApplicationController

  before_action :require_user

  def balance_summary
    org_balance_rec = OrgBalance.find_by(organisation_id: params[:organisation_id])
    return render json: {errors: ['Balanace Summary is not available for this orgnanisation']}, status: 400 if org_balance_rec.blank?
    render json: {response: OrgBalanceSerializer.new(org_balance_rec).serializable_hash}
  end
end
