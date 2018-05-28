class Plan < ApplicationRecord
  has_many :organisations
  enum plan: [ :basic, :essential, :accountant, :enterprise ]
end
