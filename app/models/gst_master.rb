# == Schema Information
#
# Table name: gst_masters
#
#  id           :integer          not null, primary key
#  name         :string
#  categaory_id :integer
#  goods        :boolean
#  rate         :decimal(10, 2)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class GstMaster < ApplicationRecord
end
