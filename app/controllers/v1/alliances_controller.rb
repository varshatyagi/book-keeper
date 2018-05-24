class V1::AlliancesController < ApplicationController

  before_action :require_user

  def index
    query_params = {organisation_id: params[:organisation_id]}
    query_params[:alliance_type] = params[:alliance_type] if params[:alliance_type].present?
    alliances = Alliance.where(query_params)
    return render json: {errors: ['Organisation has no Alliance']}, status: 400 unless alliances.present?
    alliances = alliances.map {|alliance| AllianceSerializer.new(alliance).serializable_hash}
    render json: {response: alliances}
  end

  def show
    raise 'Request Allaince is not registered for this Organisation' unless Alliance.find_by(id: params[:id]).present?
    alliance = Alliance.find(params[:id])
    render json: {response: AllianceSerializer.new(alliance).serializable_hash}
  end

  def create
    return render json: {errors: ['Required params are missing']} unless alliance_params.present?
    alliance = Alliance.new(alliance_params)
    alliance.organisation_id = params[:organisation_id]
    return render json: {errors: alliance.errors.values} unless alliance.valid?
    alliance.save
    render json: {response: AllianceSerializer.new(alliance).serializable_hash}
  end

  def destroy
    raise 'Request Allaince is not registered for this Organisation' unless Alliance.find_by(id: params[:id]).present?
    alliance = Alliance.find(params[:id])
    alliance.delete
    render json: {response: true}
  end

  private
  def alliance_params
    params.require(:alliance).permit(:name, :gstin, :alliance_type, :mob_num)
  end
end
