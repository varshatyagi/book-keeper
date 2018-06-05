class PlanSerializer < ActiveModel::Serializer
    attributes :id, :organisation_id, :plan_start_date, :plan_end_date, :amount, :plan
end
