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
  has_many :organisations

  validates_presence_of :amount, message: "Please enter amount for respective plan"
  validates_presence_of :plan, message: "Please provide plan you want to activate"
  validates_presence_of :plan_start_date, message: "Please provide when you want to start the plan"

  PLAN_ID = {
    BASIC: 1,
    ESSENTIAL: 2,
    ACCOUNTANT: 3,
    ENTERPRISE: 4
  }
end
