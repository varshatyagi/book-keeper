class V1::OrganisationsController < ApplicationController

  before_action :require_user
  # before_action :require_admin_or_organisation_owner

  def index
    organisations = Organisation.all
    organisations = organisations.map {|organisation| OrganisationSerializer.new(organisation).serializable_hash} if organisations.present?
    render json: {response: organisations}
  end

  def show
    organisation = Organisation.find(params[:id]) || not_found
    organisation = OrganisationSerializer.new(organisation).serializable_hash
    render json: {response: organisation}
  end

  def balance_summary
    organisation = Organisation.find(params[:id])
    org_balances = organisation.org_balances.by_financial_year(Common.calulate_financial_year).first
    return render json: {errors: ['Balanace Summary is not available for this orgnanisation']}, status: 400 if org_balances.blank?
    render json: {response: OrgBalanceSerializer.new(org_balances).serializable_hash}
  end

  def update
    organisation = Organisation.find(params[:id]) || not_found
    options = organisation_params
    options[:org_balances_attributes][:id] = organisation.org_balances.first.id
    options[:is_setup_complete] = true
    ApplicationRecord.transaction do
      organisation.update_attributes!(options)
    end
    render json: {response: true}, status: 200
  end

  def reports
    organisation = Organisation.find(params[:id]) || not_found

    from_date = Date.parse(params[:from]) if params[:from].present?
    to_date = Date.parse(params[:to]) if params[:to].present?

    financial_year_start = Common.calulate_financial_year
    if params[:financial_year].present?
      financial_year_start = Common.calulate_financial_year(fy: params[:financial_year])
    end

    case params[:report_type]
    when "pl"
      render json: {response: prepare_pl_report_data(from_date, to_date, organisation, financial_year_start)}
    when "account_ledger"
      render json: {response: prepare_account_ledger_report_data(from_date, to_date, organisation)}
    when "balance_sheet"
      data = prepare_balance_sheet_report_data(from_date, to_date, organisation, financial_year_start)
      render json: {response: data}
    else
      render json: {errors: ['Please provide report type']}
    end
  end

  private

  def organisation_params
    params.require(:organisation).permit(:name, :is_setup_complete, :business_start_date, org_balances_attributes: [:id, :cash_balance, :cash_opening_balance], org_bank_accounts_attributes: [:id, :bank_id, :account_num, :organisation_id, :opening_date, :financial_year, org_bank_account_balance_summary_attributes: [:id, :bank_balance, :opening_balance]])
  end

  def prepare_pl_report_data(from_date, to_date, organisation, financial_year_start)
    financial_year_end = financial_year_start + 1.year - 1.day
    transactions = {incomes: [], expenses: []}
    results = Transaction.joins(:ledger_heading).where(organisation_id: organisation.id, ledger_headings: {revenue: true}).group(:ledger_heading_id).sum(:amount)
    results = results.where("txn_date >= ? and (txn_date > ? and txn_date < ?)", from_date, financial_year_start, financial_year_end) if from_date.present?
    results = results.where("txn_date <= ? and (txn_date > ? and txn_date < ?)", to_date, financial_year_start, financial_year_end) if to_date.present?

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

  def prepare_balance_sheet_report_data(from_date, to_date, organisation, financial_year_start)
    financial_year_end = financial_year_start + 1.year - 1.day
    transactions = {assets: [], liabilities: []}
    results = Transaction.joins(:ledger_heading).where(organisation_id: organisation.id, ledger_headings: {asset: true})
                         .where("alliance_id is null")
                         .group(:ledger_heading_id).sum(:amount)
    results = results.where("txn_date >= ? and (txn_date > ? and txn_date < ?)", from_date, financial_year_start, financial_year_end) if from_date.present?
    results = results.where("txn_date <= ? and (txn_date > ? and txn_date < ?)", to_date, financial_year_start, financial_year_end) if to_date.present?

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
      credit_debit_transactions = credit_debit_transactions.where("txn_date >= ? and (txn_date > ? and txn_date < ?)", from_date, financial_year_start, financial_year_end) if from_date.present?
      credit_debit_transactions = credit_debit_transactions.where("txn_date <= ? sand (txn_date > ? and txn_date < ?)", to_date, financial_year_start, financial_year_end) if to_date.present?
    end
    # add creditors to liabilities
    if credit_debit_transactions.present?
      transactions[:liabilities] << {ledger_heading: "Creditors", amount: credit_debit_transactions["creditors"].to_f}
      transactions[:assets] << {ledger_heading: "Debitors", amount: credit_debit_transactions["debitors"].to_f}
    end

    transactions
  end

  def prepare_account_ledger_report_data(from_date, to_date, organisation, financial_year_start)
    financial_year_end = financial_year_start + 1.year - 1.day
    scope = Transaction.includes(:ledger_heading).joins(:ledger_heading)
    scope = scope.where(organisation_id: organisation.id)
    if params[:ledger_heading_ids].present?
      scope = scope.where(ledger_heading_id: params[:ledger_heading_ids])
    end
    scope = scope.where("txn_date >= ? and (txn_date > ? and txn_date < ?)", from_date, financial_year_start, financial_year_end) if from_date.present?
    scope = scope.where("txn_date <= ? and (txn_date > ? and txn_date < ?)", to_date, financial_year_start, financial_year_end) if to_date.present?
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
