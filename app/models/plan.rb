class Plan < ApplicationRecord
  has_many :organisations

  PLAN = {
    "BASIC": "Basic",
    "ESSENTIAL": "Essential",
    "ACCOUNTANT": "Accountant",
    "ENTERPRISE": "Enterprise"
  }
end
