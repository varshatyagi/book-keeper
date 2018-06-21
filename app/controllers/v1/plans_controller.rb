class V1::PlansController < ApplicationController

  before_action :require_user
  before_action :require_admin, only: [:create, :update]

  def create
    organisation = Organisation.find(params[:organisation_id]) || not_found
    plan = Plan.new(plan_params)
    plan[:plan_end_date] = plan[:plan_start_date] + 1.year if plan_params[:plan_end_date].blank?
    ApplicationRecord.transaction do
      plan.save!
      organisation.update_attributes!(active_plan_id: plan.plan)
      user = User.find(organisation.owner_id)
      if user.mob_num.present?
        user_signup_via_mobile(user)
      else
        user_signup_via_email(user)
      end
    end
    render json: {response: PlanSerializer.new(plan).serializable_hash}
  end

  def update
    plan = Plan.find(params[:id]) || not_found
    organisation = Organisation.find(params[:organisation_id])
    ApplicationRecord.transaction do
      plan.update_attributes!(plan_params)
      organisation.update_attributes!(active_plan_id: plan.plan)
    end
    render json: {response: PlanSerializer.new(plan).serializable_hash}
  end

  def show
    plan = Plan.find(params[:id]) || not_found
    render json: {response: PlanSerializer.new(plan).serializable_hash}, status: 200
  end

  private

  def plan_params
    params.require(:plan).permit(:amount, :plan_start_date, :plan_end_date, :plan, :organisation_id, :remarks) if params[:plan]
  end

  def user_signup_via_mobile(user)
    url_code = Common.short_url_code(User::LOGIN_URL)
    message = "Thank you. Your plan has been activated. Please click on below link to login to your account #{User::BASE_URL}#{url_code}"
    Common.send_sms({message: message, mob_num: user.mob_num})
    user.update_attributes!(status: User::USER_STATUS_ACTIVE)
  end

  def user_signup_via_email(user)
    password = Common.generate_string
    user.update_attributes!({
      status: User::USER_STATUS_ACTIVE,
      password: password,
      password_confirmation: password,
      is_temporary_password: true
    })
    OrganizationNotifierMailer.plan_activated(user, password).deliver
  end
end
