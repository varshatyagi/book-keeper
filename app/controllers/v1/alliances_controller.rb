class V1::AlliancesController < ApplicationController

  before_action :require_user

  def index
    query_params = {organisation_id: params[:organisation_id]}
    query_params[:alliance_type] = params[:alliance_type] if params[:alliance_type].present?
    alliances = Alliance.where(query_params)
    alliances = alliances.map {|alliance| AllianceSerializer.new(alliance).serializable_hash} if alliances.present?
    render json: {response: alliances}
  end

  def show
    alliance = Alliance.find(id: params[:id]) || not_found
    render json: {response: AllianceSerializer.new(alliance).serializable_hash}
  end

  def create
    alliance = Alliance.new(alliance_params)
    alliance.organisation_id = params[:organisation_id]
    return render json: {errors: alliance.errors.values.flatten(2)}, status: 400 unless alliance.valid?
    alliance.save
    render json: {response: AllianceSerializer.new(alliance).serializable_hash}
  end

  def destroy
    alliance = Alliance.find_by(id: params[:id]) || not_found
    alliance.destroy
    render json: {response: true}
  end

  private
  def alliance_params
    params.require(:alliance).permit(:name, :gstin, :alliance_type, :mob_num, :email)
  end
end
