class V1::OrganisationsController < ApplicationController

  # before_action :require_user
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
    organisation = Organisation.find(params[:id]) || not_found

    from_date = Date.parse(params[:from]) if params[:from].present?
    to_date = Date.parse(params[:to]) if params[:to].present?

    case params[:report_type]
    when "pl"
      render json: {response: prepare_pl_report_data(from_date, to_date, organisation)}
    when "account_ledger"
      data = prepare_account_ledger_report_data(from_date, to_date, organisation)
      render json: {response: data}
    when "balance_sheet"
      data = prepare_balance_sheet_report_data(from_date, to_date, organisation)
      render json: {response: data}
    else
      render json: {errors: ['Please provide report type']}
    end
  end

  def ledger_heading_report_pdf
    respond_to do |format|
      format.pdf do
        pdf = Prawn::Document.new
        pdf.text "Hellow World!"
        send_data pdf.render,
          filename: "export.pdf",
          type: 'application/pdf',
          disposition: 'inline'
      end
    end
  end

  private

  def organisation_params
    params.require(:organisation).permit(:name, org_bank_accounts_attributes: [:id, :bank_id, :account_num, :bank_balance, :initial_balance, :organisation_id])
  end

  def prepare_pl_report_data(from_date, to_date, organisation)
    transactions = {incomes: [], expenses: []}
    results = Transaction.joins(:ledger_heading).where(organisation_id: organisation.id, ledger_headings: {revenue: true}).group(:ledger_heading_id).sum(:amount)
    results = results.where("txn_date >= ?", from_date) if from_date.present?
    results = results.where("txn_date <= ?", to_date) if to_date.present?

    ledger_heading_ids = results.keys
    ledger_heading_by_ids = {}
    if ledger_heading_ids.present?
      ledger_headings = LedgerHeading.where(id: ledger_heading_ids)
      ledger_headings.each do |ledger_heading|
        ledger_heading_by_ids[ledger_heading.id.to_s] = ledger_heading
      end
    end

    results.each do |ledger_heading_id, total|
      ledger_heading = ledger_heading_by_ids[ledger_heading_id.to_s]
      info = {ledger_heading: ledger_heading.name, amount: total.to_f}
      if ledger_heading.transaction_type == LedgerHeading::TRANSACTION_TYPE_CREDIT
        transactions[:incomes] << info
      else
        transactions[:expenses] << info
      end
    end
    transactions
  end

  def prepare_balance_sheet_report_data(from_date, to_date, organisation)
    transactions = {assets: [], liabilities: []}
    results = Transaction.joins(:ledger_heading).where(organisation_id: organisation.id, ledger_headings: {asset: true})
                         .where("alliance_id is null")
                         .group(:ledger_heading_id).sum(:amount)
    results = results.where("txn_date >= ?", from_date) if from_date.present?
    results = results.where("txn_date <= ?", to_date) if to_date.present?

    ledger_heading_ids = results.keys
    ledger_heading_by_ids = {}
    if ledger_heading_ids.present?
      ledger_headings = LedgerHeading.where(id: ledger_heading_ids)
      ledger_headings.each do |ledger_heading|
        ledger_heading_by_ids[ledger_heading.id.to_s] = ledger_heading
      end
    end

    results.each do |ledger_heading_id, total|
      ledger_heading = ledger_heading_by_ids[ledger_heading_id.to_s]
      info = {ledger_heading: ledger_heading.name, amount: total.to_f}
      if ledger_heading.transaction_type == LedgerHeading::TRANSACTION_TYPE_CREDIT
        transactions[:liabilities] << info
      else
        transactions[:assets] << info
      end
    end

    # add bank bal, cash bal, debitors in assets
    transactions[:assets] << {ledger_heading: "Bank A/C", amount: organisation.org_balance.bank_balance.to_f}
    transactions[:assets] << {ledger_heading: "Cash A/C", amount: organisation.org_balance.cash_balance.to_f}

    # joins transactions and alliances where alliance_type = debit in the from to to_date
    credit_debit_transactions = Transaction.joins(:alliance).where(organisation_id: organisation.id).where("alliance_id is not null").group("alliances.alliance_type").sum(:amount)
    if from_date.blank?
      credit_debit_transactions = credit_debit_transactions
    else
      credit_debit_transactions = credit_debit_transactions.where("txn_date >= ?", from_date) if from_date.present?
      credit_debit_transactions = credit_debit_transactions.where("txn_date <= ?", to_date) if to_date.present?
    end
    # add creditors to liabilities
    if credit_debit_transactions.present?
      transactions[:liabilities] << {ledger_heading: "Creditors", amount: credit_debit_transactions[0].to_f}
      transactions[:assets] << {ledger_heading: "Debitors", amount: credit_debit_transactions[1].to_f}
    end

    transactions
  end

  def prepare_account_ledger_report_data(from_date, to_date, organisation)
    scope = Transaction.includes(:ledger_heading).joins(:ledger_heading)
    scope = scope.where(organisation_id: organisation.id)
    if params[:ledger_heading_ids].present?
      scope = scope.where(ledger_heading_id: params[:ledger_heading_ids])
    end
    scope = scope.where("txn_date >= ?", from_date) if from_date.present?
    scope = scope.where("txn_date <= ?", to_date) if to_date.present?
    scope.order(txn_date: :asc)

    transactions = []
    scope.each do |transaction|
      transactions << {
        ledger_heading: transaction.ledger_heading.name,
        txn_date: transaction.txn_date.strftime("%d-%m-%Y"),
        transaction_type: transaction.ledger_heading.transaction_type,
        amount: transaction.amount.to_f,
        remarks: transaction.remarks
      }
    end
    transactions
  end
end
