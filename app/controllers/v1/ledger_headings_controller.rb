class V1::LedgerHeadingsController < ApplicationController

  before_action :require_user
  before_action :require_admin, only: [:create, :update, :destroy]

  def index
    render json: {response: prepare_ledger_headings}
  end

  def show
    ledger_heading = LedgerHeading.find(params[:id]) || not_found
    ledger_heading = LedgerHeadingSerializer.new(ledger_heading).serializable_hash
    render json: {response: ledger_heading}
  end

  def create
    ledger_heading = LedgerHeading.new(ledger_heading_params)
    ledger_heading.save!
    render json: {response: LedgerHeadingSerializer.new(ledger_heading).serializable_hash}
  end

  def update
    ledger_heading = LedgerHeading.find(params[:id])
    ledger_heading.update_attributes!(ledger_heading_params)
    render json: {response: LedgerHeadingSerializer.new(ledger_heading).serializable_hash}
  end

  def destroy
    LedgerHeading.find(params[:id]).destroy
    render json: {response: true}
  end

  private

  def prepare_ledger_headings
    scope = LedgerHeading.all.order(:display_name)
    scope = scope.where('transaction_type != ?', LedgerHeading::CASH_TRANSACTION).where('name NOT IN (?)', [LedgerHeading::CAPITAL_ACCRUED_CASH, LedgerHeading::CAPITAL_ACCRUED_BANK])
    if params[:transaction_type].present?
      scope = scope.where(transaction_type: params[:transaction_type])
    end
    if params[:revenue].present?
      scope = scope.where(revenue: true?(params[:revenue]))
    end
    if params[:asset].present?
      scope = scope.where(asset: true?(params[:asset]))
    end
    scope = scope.paginate(:page => params[:page_start], :per_page => params[:limit]) if params[:page_start].present? && params[:limit].present?
    records = scope.length
    ledger_headings = scope.to_a
    ledger_headings = ledger_headings.map {|ledger_heading| LedgerHeadingSerializer.new(ledger_heading).serializable_hash} if ledger_headings.present?
    {total_records: records, ledger_headings: ledger_headings}
  end

  private
  def ledger_heading_params
    params.require(:ledger_heading).permit(:display_name, :revenue, :transaction_type, :asset)
  end

  def true?(obj)
    obj.to_s == "true"
  end
end
