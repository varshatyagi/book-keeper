class V1::PlansController < ApplicationController

  def create
    organisation = Organisation.find_by(id: params[:organisation_id]) || not_found
    plan = Plan.new(plan_params)
    plan[:plan_end_date] = plan[:plan_start_date] + 1.year
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
    render json: {response: [true]}
  end

  def update
    plan = Plan.find(params[:id]) || not_found
    plan[:plan_end_date] = plan[:plan_start_date] + 1.year
    ApplicationRecord.transaction do
      plan.save!
      organisation.update_attributes!(active_plan_id: plan.plan)
    end
    render json: {response: [true]}
  end

  private

  def plan_params
    params.require(:plan).permit(:amount, :plan_start_date, :plan_end_date, :plan, :organisation_id) if params[:plan]
  end

  def user_signup_via_mobile(user)
    # TODO: send mail to user to sign up the user
    user.update_attributes!(status: User::USER_STATUS_ACTIVE)
  end

  def user_signup_via_email(user)
    # TODO: send mail to user to sign up the user with is_temporary_password
    user.update_attributes!({
      status: User::USER_STATUS_ACTIVE,
      password: Common.generate_string,
      password_confirmation: Common.generate_string,
      is_temporary_password: true
    })
  end
end
