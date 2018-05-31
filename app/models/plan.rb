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
  enum status: {basic: 1, essential: 2, accountant: 3, enterprise: 4}
end
