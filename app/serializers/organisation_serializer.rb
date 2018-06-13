class OrganisationSerializer < ActiveModel::Serializer
  attributes :id, :name, :owner_id, :created_by, :is_setup_complete, :owner, :preferred_plan_id
  attributes :active_plan_id, :created_at, :balance_summary, :plan_info

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
      plan_info = {active_plan_id: active_id}
    elsif object.user.status == User::USER_STATUS_ACTIVE
      plan_detail = object.plan
      # if plan end date is smaller than current time than expired flag is true
      expired = plan_detail && plan_detail.plan_end_date ? plan_detail.plan_end_date < DateTime.now : nil
      plan_info = { id: plan_detail ? plan_detail.id : nil,
                    active_plan_id: active_id ? active_id : nil,
                    active_plan_name: active_id ? Plan::PLAN_NAME[active_id] : nil,
                    plan_start_date: plan_detail && plan_detail.plan_start_date ? plan_detail.plan_start_date : nil,
                    plan_end_date: plan_detail && plan_detail.plan_end_date ? plan_detail.plan_end_date : nil,
                    amount: plan_detail && plan_detail.amount.to_f ? plan_detail.amount.to_f : nil,
                    expired: expired
                  }
    end
      return plan_info
  end

  def balance_summary
    org_balance = object.org_balances.by_financial_year(Common.calulate_financial_year).first
    return {
      cash_balance: org_balance && org_balance.cash_balance && org_balance.cash_balance > 0 ? org_balance && org_balance.cash_balance : 0,
      cash_opening_balance: org_balance && org_balance.cash_opening_balance && org_balance.cash_opening_balance > 0 ? org_balance && org_balance.cash_opening_balance : 0,
      id: org_balance && org_balance.id ? org_balance && org_balance.id : nil
    }
  end
end
