class V1::LedgerHeadingsController < ApplicationController

  before_action :require_user

  def index
    render json: {response: prepare_ledger_headings}
  end

  private

  def prepare_ledger_headings
    scope = LedgerHeading.all
    if params[:transaction_type].present?
      scope = scope.where(transaction_type: params[:transaction_type])
    end
    if params[:revenue].present?
      # TODO: except internal heading return all
      scope = scope.where(revenue: params[:revenue])
    end

    if params[:asset].present?
      # TODO: except internal heading return all
      scope = scope.where(asset: params[:asset])
    end

    ledger_headings = scope.to_a
    ledger_headings = ledger_headings.map {|ledger_heading| LedgerHeadingSerializer.new(ledger_heading).serializable_hash} if ledger_headings.present?
    ledger_headings
  end

  def ledger_heading_params
    params.permit([:name, :revenue, :transaction_type, :asset])
  end
end
