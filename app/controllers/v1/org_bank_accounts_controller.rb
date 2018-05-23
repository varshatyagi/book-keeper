class V1::OrgBankAccountsController < ApplicationController

  before_action :require_user
  # before_action :require_admin_or_organisation_owner

  def index
    org_bank_accounts = OrgBankAccount.where({organisation_id: params[:organisation_id]})
    org_bank_accounts = org_bank_accounts.map { |org_bank_account| OrgBankAccountSerializer.new(org_bank_account).serializable_hash} if org_bank_accounts.present?
    render json: {response: org_bank_accounts}
  end
end
