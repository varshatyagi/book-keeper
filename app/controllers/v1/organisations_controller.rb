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

  def reports
    to = Time.at(params[:to].to_i) if params[:to].present?
    from = Time.at(params[:from].to_i) if params[:from].present?

    case params[:type]
    when "pl"
      data = pl_report(to, from)
      return render json: {response: data}
    when "ledger"
      ledger_heading_report(to, from)
      return render json: {response: data.flatten(2)}
    when "balance_sheet"
      balance_sheet_report
    else
      return render json: {errors: ['Please provide report type']}
    end
  end

  private

  def organisation_params
    params.require(:organisation).permit(:name, org_bank_accounts_attributes: [:id, :bank_id, :account_num, :bank_balance, :initial_balance, :organisation_id])
  end

  def pl_report(to, from)
    rec_hash = Hash.new
    data = Hash.new
    rec_hash[:revenue] = Transaction.joins(:ledger_heading).where(ledger_headings: {revenue: true})
    rec_hash[:asset] = Transaction.joins(:ledger_heading).where(ledger_headings: {asset: true})
    if to.present? && from.present?
      rec_hash[:revenue] = rec_hash[:revenue].where(created_at: from..to)
      rec_hash[:asset] = rec_hash[:asset].where(created_at: from..to)
    end
    return nil if rec_hash.blank?
    rec_hash.each do |key, value|
      data[key] = calculate_total_sum(value.group_by(&:ledger_heading_id))
    end
    data
  end

  def ledger_heading_report(to, from)
    scope = Transaction.all
    if to.present? && from.present?
      scope = scope.where(created_at: from..to)
    end
    transactions = []
    records.each do |record|
      heading = LedgerHeading.find_by(record.ledger_heading_id.to_s)
      transactions << {ledger_heading: heading.name, txn_date: record.txn_date, transaction_type: heading.transaction_type}
    end
    transactions
  end

  def calculate_total_sum(transactions)
    transaction_records = []
    transactions.each do |transaction|
      transaction[1].collect(&:amount).sum
      heading = LedgerHeading.find_by(transaction[0].to_s).name
      transaction_records << {ledger_heading: heading, amount: transaction[1].collect(&:amount).sum}
    end
    transaction_records
  end

end
