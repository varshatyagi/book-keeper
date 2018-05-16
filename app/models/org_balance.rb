class OrgBalance < ApplicationRecord
  belongs_to :organisation, optional: true
  # validates_presence_of :financial_year_start
end
