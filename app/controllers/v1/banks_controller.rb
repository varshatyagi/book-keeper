class V1::BanksController < ApplicationController

  before_action :require_user

  def index
    banks = Bank.all
    banks = bank.map {|bank| BankSerializer.new(bank).serializable_hash} if banks.present?
    render json: {response: banks}
  end
end
