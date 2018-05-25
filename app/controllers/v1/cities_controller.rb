class V1::CitiesController < ApplicationController

  def index
    cities = City.all
    cities = cities.map {|city| CitySerializer.new(city).serializable_hash} if cities.present?
    render json: {response: cities}

  end
end
