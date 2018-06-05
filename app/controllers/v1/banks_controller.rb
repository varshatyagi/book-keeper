class V1::BanksController < ApplicationController

  def index
    banks = Bank.all
    banks = banks.map {|bank| BankSerializer.new(bank).serializable_hash} if banks.present?
    render json: {response: banks}
  end
end
