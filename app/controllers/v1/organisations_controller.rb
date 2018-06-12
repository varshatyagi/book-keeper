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
    organisation = Organisation.find(params[:id]) || not_found
    org_balance = organisation.org_balances.by_financial_year(Common.calulate_financial_year).first
    render json: {response: OrgBalanceSerializer.new(org_balance).serializable_hash}
  end

  def update
    organisation = Organisation.find(params[:id]) || not_found
    options = organisation_params
    ApplicationRecord.transaction do
      organisation.update_attributes!(options)
    end
    render json: {response: OrganisationSerializer.new(organisation).serializable_hash}
  end

  def reports
    organisation = Organisation.find(params[:id]) || not_found

    from_date = Date.parse(params[:from_date]) if params[:from_date].present?
    to_date = Date.parse(params[:to_date]) if params[:to_date].present?

    if from_date.present?
      financial_year_start = Common.calulate_financial_year(fy: from_date)
    else
      financial_year_start = Common.calulate_financial_year
    end

    case params[:report_type]
    when Organisation::REPORT_TYPE_PROFIT_AND_LOSS
      render json: {response: prepare_pl_report_data(from_date, to_date, organisation, financial_year_start)}
    when Organisation::REPORT_TYPE_ACCOUNT_LEDGER
      render json: {response: prepare_account_ledger_report_data(from_date, to_date, organisation, financial_year_start)}
    when Organisation::REPORT_TYPE_BALANCE_SHEET
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
    financial_year_end = financial_year_start + 1.year
    transactions = {incomes: [], expenses: []}

    results = Transaction.joins(:ledger_heading).where("organisation_id = ? ", organisation_id)
                          .where("ledger_headings.revenue = ?", true)

    results = results.where("txn_date >= ?", from_date) if from_date.present?
    results = results.where("txn_date <= ?", to_date) if to_date.present?

    unless from_date.present?
      results = results.where("txn_date >= ? and txn_date < ?)", financial_year_start, financial_year_end)
    end

    results = results.group(:ledger_heading_id).sum(:amount)
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
    financial_year_end = financial_year_start + 1.year
    transactions = {assets: [], liabilities: []}

    results = Transaction.joins(:ledger_heading).where("organisation_id = ?", organisation_id)
                          .where("ledger_headings.asset = ?", true)
                          .where("alliance_id is null")

    results = results.where("txn_date >= ?", from_date) if from_date.present?
    results = results.where("txn_date <= ?", to_date) if to_date.present?

    unless from_date.present?
      results = results.where("txn_date >= ? and txn_date < ?)", financial_year_start, financial_year_end)
    end

    results = results.group(:ledger_heading_id).sum(:amount)

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
    # calcuate pl of the year
    income = 0
    expense = 0
    profit_loss_records = prepare_pl_report_data(from_date, to_date, organisation, financial_year_start)
    if profit_loss_records[:incomes].present?
      income = collect_sum(profit_loss_records[:incomes])
    end

    if profit_loss_records[:expenses].present?
      expense = collect_sum(profit_loss_records[:expenses])
    end

    if income > expense
      transactions[:liabilities] << {ledger_heading: "Profit of the year", amount: (income - expense)}
    else
      transactions[:assets] << {ledger_heading: "Loss of the year", amount: (expense - income)}
    end

    org_balance = organisation.org_balances.by_financial_year(Common.calulate_financial_year(fy: financial_year_start)).first
    # add bank bal, cash bal, debitors in assets
    transactions[:assets] << {ledger_heading: "Bank A/C", amount: org_balance.bank_balance.to_f}
    transactions[:assets] << {ledger_heading: "Cash A/C", amount: org_balance.cash_balance.to_f}
    transactions[:assets] << {ledger_heading: "Debtors", amount: org_balance.debit_balance.to_f}
    transactions[:liabilities] << {ledger_heading: "Creditors", amount: org_balance.credit_balance.to_f} if liabilities.present?

    transactions
  end

  def prepare_account_ledger_report_data(from_date, to_date, organisation, financial_year_start)
    financial_year_end = financial_year_start + 1.year

    scope = Transaction.includes(:ledger_heading).joins(:ledger_heading).where("organisation_id = ?", organisation_id)

    scope = scope.where("txn_date >= ?", from_date) if from_date.present?
    scope = scope.where("txn_date <= ?", to_date) if to_date.present?

    unless from_date.present?
      scope = scope.where("txn_date >= ? and txn_date < ?)", financial_year_start, financial_year_end)
    end

    scope_condittion = {}
    scope_condittion[:alliance_id] = params[:alliance_id] if params[:alliance_id].present?
    scope_condittion[:ledger_heading_ids] = params[:ledger_heading_ids] if params[:ledger_heading_ids].present?
    scope = scope.where(scope_condittion) if scope_condittion.present?
    scope.order(txn_date: :asc)

    transactions = []
    scope.each do |transaction|
      transactions << {
        ledger_heading: transaction.ledger_heading.display_name,
        txn_date: transaction.txn_date.strftime("%d-%m-%Y"),
        transaction_type: transaction.ledger_heading.transaction_type,
        amount: transaction.amount.to_f,
        remarks: transaction.remarks
      }
    end
    transactions
  end

  def collect_sum(records)
    sum = 0
    records.each do |record|
      sum += record.amount
    end
    sum
  end
end
