class V1::LedgerHeadingsController < ApplicationController

  before_action :require_user

  def index
    render json: {response: prepare_ledger_headings}
  end

  def create
    ledger_heading = LedgerHeading.new(ledger_heading_params)
    ledger_heading.save!
    render json: {response: true}
  end

  def update
    ledger_heading = LedgerHeading.find(params[:id])
    ledger_heading = ledger_heading.update_attributes!(ledger_heading_params)
    render json: {response: true}
  end

  def destroy
    LedgerHeading.find(params[:id]).destroy
    render json: {response: true}
  end

  private

  def prepare_ledger_headings
    scope = LedgerHeading.all
    if params[:transaction_type].present?
      scope = scope.where(transaction_type: params[:transaction_type])
    end
    if params[:revenue].present?
      # TODO: except internal heading return all
      scope = scope.where(revenue: true?(params[:revenue]))
    end
    if params[:asset].present?
      # TODO: except internal heading return all
      scope = scope.where(asset: true?(params[:asset]))
    end

    ledger_headings = scope.to_a
    ledger_headings = ledger_headings.map {|ledger_heading| LedgerHeadingSerializer.new(ledger_heading).serializable_hash} if ledger_headings.present?
    ledger_headings
  end

  private
  def ledger_heading_params
    params.require(:ledger_heading).permit(:name, :revenue, :transaction_type, :asset)
  end

  def true?(obj)
    obj.to_s == "true"
  end
end
