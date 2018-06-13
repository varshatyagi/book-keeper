# == Schema Information
#
# Table name: plans
#
#  id              :integer          not null, primary key
#  organisation_id :integer
#  plan            :integer
#  plan_start_date :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  plan_end_date   :datetime
#
# Indexes
#
#  index_plans_on_organisation_id  (organisation_id)
#  index_plans_on_plan_start_date  (plan_start_date)
#

class Plan < ApplicationRecord
  belongs_to :organisation, optional: true

  validates_presence_of :amount, message: "Please enter amount for respective plan"
  validates_presence_of :plan, message: "Please provide plan you want to activate"
  validates_presence_of :plan_start_date, message: "Please provide when you want to start the plan"
  validates_presence_of :organisation_id, message: "Organisation is missing"
  validates_uniqueness_of :organisation_id, message: "For one Organisation there should be only one Plan."

  PLAN_NAME = ["Basic", "Essential", "Accountant", "Enterprise"]

  def plan_name
    PLAN_NAME[plan]
  end
end
