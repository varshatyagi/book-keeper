class V1::StatesController < ApplicationController

  def index
    states = State.all
    states = states.map {|state| StateSerializer.new(state).serializable_hash} if states.present?
    render json: {response: states}

  end
end
