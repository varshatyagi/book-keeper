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
    to = Time.at(params[:to].to_i/1000) if params[:to].present?
    from = Time.at(params[:from].to_i/1000) if params[:from].present?
    rec_hash = Hash.new

    case params[:type]
    when "pl"
      rec_hash[:income] = Transaction.joins(:ledger_heading).where(ledger_headings: {revenue: true, transaction_type: "credit"})
      rec_hash[:expense] = Transaction.joins(:ledger_heading).where(ledger_headings: {asset: true, transaction_type: "debit"})
      data = prepare_report_records(to, from, rec_hash)
      return render json: {response: data}

    when "ledger"
      data = ledger_heading_report(to, from)
      return render json: {response: data}

    when "balance_sheet"
      rec_hash[:income] = Transaction.joins(:ledger_heading).where(ledger_headings: {asset: true, transaction_type: "credit"})
      rec_hash[:expense] = Transaction.joins(:ledger_heading).where(ledger_headings: {asset: true, transaction_type: "debit"})
      data = prepare_report_records(to, from, rec_hash)
      org_rec = OrgBalance.find_by(organisation_id: params[:id])
      bank_details = {cash_balance: org_rec.cash_balance, bank_balance: org_rec.bank_balance}
      return render json: {response: {data: data, bank_details: bank_details}}

    else
      return render json: {errors: ['Please provide report type']}
    end
  end

  private

  def organisation_params
    params.require(:organisation).permit(:name, org_bank_accounts_attributes: [:id, :bank_id, :account_num, :bank_balance, :initial_balance, :organisation_id])
  end

  def prepare_report_records(to, from, rec_hash)
    data = Hash.new
    if to.present? && from.present?
      rec_hash[:income] = rec_hash[:income].where(txn_date: from..to)
      rec_hash[:expense] = rec_hash[:expense].where(txn_date: from..to)
    end
    return nil if rec_hash.blank?
    rec_hash.each do |key, value|
      data[key] = calculate_total_sum(value.group_by(&:ledger_heading_id))
    end
    data
  end

  def ledger_heading_report(to, from)
    if params[:ledger_headings].present?
      scope = Transaction.where(ledger_heading_id: params[:ledger_headings])
    else
      scope = Transaction.all
    end
    if to.present? && from.present?
      scope = scope.where(created_at: from..to)
    end

    transactions = []
    scope.each do |record|
      heading = LedgerHeading.find_by(id: record.ledger_heading_id)
      transactions << {ledger_heading: heading.name, txn_date: record.txn_date, transaction_type: heading.transaction_type, amount: record.amount}
    end
    transactions
  end

  def calculate_total_sum(transactions)
    transaction_records = []
    transactions.each do |transaction|
      transaction[1].collect(&:amount).sum
      heading = LedgerHeading.find(transaction[0]).name
      transaction_records << {ledger_heading: heading, amount: transaction[1].collect(&:amount).sum}
    end
    transaction_records
  end

end
