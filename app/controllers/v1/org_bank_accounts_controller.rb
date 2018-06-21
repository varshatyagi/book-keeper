class V1::OrgBankAccountsController < ApplicationController

  before_action :require_user

  def index
    organisation = Organisation.find(params[:organisation_id]) || not_found
    org_bank_accounts = organisation.org_bank_accounts
    org_bank_accounts = org_bank_accounts.to_a
    org_bank_accounts = org_bank_accounts.map { |org_bank_account| OrgBankAccountSerializer.new(org_bank_account).serializable_hash} if org_bank_accounts.present?
    render json: {response: org_bank_accounts}
  end
end
