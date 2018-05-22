class V1::AlliancesController < ApplicationController

  def index
    alliances = Alliance.find_by(organisation_id: params[:organisation_id])
    alliances = alliances.map {|alliance| AllianceSerializer.new(alliance).serializable_hash} if alliances.present?
    render json: {response: alliances}
  end

  def show # need to check again
    alliances = Alliance.where(params)
    render json: {response: AllianceSerializer.new(alliance).serializable_hash}
  end

  def create
    return render json: {errors: ['Required params are missing']} unless alliance_params.present?
    alliance = Alliance.new(alliance_params)
    return render json: {errors: alliance.errors.values} unless alliance.valid?
    alliance.save
    render json: {response: AllianceSerializer.new(alliance).serializable_hash}
  end

  def destroy
    alliance = Alliance.find(params[:id])
    render json: {errors: ['Alliance is not registered']} unless alliance.present?
    alliance.destory
    render json: {response: true}
  end

  private
  def alliance_params
    params.required(:alliance).permit(:name, :gstin, :alliance_type, :email)
  end
end
