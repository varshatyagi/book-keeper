class V1::Admin::PlansController < ApplicationController

  def plan_info
    raise 'No Plan found for this organisation' unless Plan.find(params[:id])
    plan = Plan.find(params[:id])
    render json: {response: PlanSerializer.new(plan).serializable_hash}
  end

  def update
    raise 'No plan exist for this organisation' unless Plan.find_by(id: params[:id])
    plan = Plan.find(params[:id])
    organisation = Organisation.find(plan.organisation_id)
    options = plan_params
    plan_start_date = Date.parse(plan_params[:plan_start_date])
    options[:plan_end_date] = plan_start_date + 1.year
    ApplicationRecord.transaction do
      plan.update_attributes!(options)
      organisation.update_attributes!(active_plan_id: plan.plan)
      user = User.find(organisation.owner_id)
      user_signup_via_mobile(user) if user.mob_num.present?
      user_signup_via_email(user) if user.email.present?
    end
    render json: {response: [true]}
  end

  private

  def plan_params
    params.require(:plan).permit(:amount, :plan_start_date, :plan_end_date, :plan) if params[:plan]
  end

  def user_signup_via_mobile(user)
    # TODO: send mail to user to sign up the user
    user.update_attributes!(status: Plan::USER_STATUS_ACTIVE)
  end

  def user_signup_via_email(user)
    # TODO: send mail to user to sign up the user with is_temporary_password
    user.update_attributes!({
      status: Plan::USER_STATUS_ACTIVE,
      password: Common.generate_string,
      password_confirmation: Common.generate_string,
      is_temporary_password: true
    })
  end
end
