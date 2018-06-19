class PlanSerializer < ActiveModel::Serializer
    attributes :id, :organisation_id, :plan_start_date, :plan_end_date, :amount, :plan, :remarks

    def amount
      object.amount.to_f
    end

    def plan_start_date
      object.plan_start_date.strftime('%m/%d/%Y')
    end

    def plan_end_date
      object.plan_end_date.strftime('%m/%d/%Y')
    end
end
