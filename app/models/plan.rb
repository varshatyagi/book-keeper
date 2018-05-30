class Plan < ApplicationRecord
  has_many :organisations
  enum status: {basic: 1, essential: 2, accountant: 3, enterprise: 4}
end
