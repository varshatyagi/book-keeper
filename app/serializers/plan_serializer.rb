class PlanSerializer < ActiveModel::Serializer
    attributes :id, :organisation_id, :plan_start_date, :plan_end_date, :amount, :plan

    def amount
      object.amount = object.amount.to_f
    end
end
