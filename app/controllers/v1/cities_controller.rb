class V1::CitiesController < ApplicationController

  def index
    city_scope = City.all
    byebug
    city_scope = city_scope.where(state_code: params[:state_code].upcase) if params[:state_code].present?
    cities = city_scope
    cities = cities.map {|city| CitySerializer.new(city).serializable_hash} if cities.present?
    render json: {response: cities}
  end
end
