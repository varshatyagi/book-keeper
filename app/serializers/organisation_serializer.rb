class OrganisationSerializer < ActiveModel::Serializer
  attributes :id, :name, :owner_id, :created_by, :owner, :plan_info

  def owner
    return nil if object.id.blank?
    user = User.find_by(organisation_id: object.id)
    {id: user.id, name: user.name, mob_num: user.mob_num, email: user.email, role: user.role, city: user.city, state: user.state_code}
  end

  def plan_info
    active_id = object.active_plan_id
    if active_id.blank?
      active_id = nil
    end
    preferred_id = object.preferred_plan_id
    if object.user.status == User::USER_STATUS_PENDING
      return {active_plan_id: active_id}
    elsif object.user.status == User::USER_STATUS_ACTIVE
      plan_detail = object.plan
    end
      return {
              active_plan_id: active_id,
              active_plan_name: Plan::PLAN_NAME[active_id],
              plan_start_date: plan_detail.plan_start_date,
              plan_end_date: plan_detail.plan_end_date,
              amount: plan_detail.amount.to_f
            }
  end
end
