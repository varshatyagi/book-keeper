# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string
#  state_code :string
#

class City < ApplicationRecord
  # belongs_to :state, optional: true, foreign_key: 'code'
end
