class OrganisationSerializer < ActiveModel::Serializer
  attributes :id, :name, :owner_id, :created_by, :owner, :is_setup_complete, :plan_info

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
      # if plan end date is smaller than current time than expired flag is true
      expired = plan_detail && plan_detail.plan_end_date ? plan_detail.plan_end_date < DateTime.now : nil
    end
      return {
              active_plan_id: active_id ? active_id : nil,
              active_plan_name: active_id ? Plan::PLAN_NAME[active_id] : nil,
              plan_start_date: plan_detail && plan_detail.plan_start_date ? plan_detail.plan_start_date : nil,
              plan_end_date: plan_detail && plan_detail.plan_end_date ? plan_detail.plan_end_date : nil,
              amount: plan_detail && plan_detail.amount.to_f ? plan_detail.amount.to_f : nil,
              expired: expired
            }
  end
end
