class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :mob_num, :email, :token, :role, :organisation_id, :city, :address
  attributes :state_code, :status, :is_temporary_password, :plan_info

  def plan_info
    organisation = Organisation.find(object.organisation_id)
    active_id = organisation.active_plan_id
    if active_id.blank?
      active_id = nil
    end
    preferred_id = organisation.preferred_plan_id
    if object.status == User::USER_STATUS_PENDING
      return {preferred_plan_id: preferred_id, active_plan_id: active_id}
    elsif object.status == User::USER_STATUS_ACTIVE
      plan_detail = Plan.find(object.organisation_id)
      return { preferred_plan_id: preferred_id,
              active_plan_id: active_id,
              plan_start_date: plan_detail.plan_start_date,
              plan_end_date: plan_detail.plan_end_date
            }
    end


  end
end
