# == Schema Information
#
# Table name: sp_entries
#
#  id           :integer          not null, primary key
#  bill_no      :string
#  entry_date   :datetime
#  status       :string
#  gstin        :string
#  party        :string
#  mob_num      :string
#  payment_mode :string
#  gst_total    :decimal(10, 2)
#  created_by   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class SpEntry < ApplicationRecord
end
