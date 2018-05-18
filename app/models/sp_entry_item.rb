# == Schema Information
#
# Table name: sp_entry_items
#
#  id                    :integer          not null, primary key
#  entry_id              :integer
#  item_name             :string
#  status                :string
#  quanity               :integer
#  amount                :decimal(, )
#  gst_master_id         :integer
#  gst_amt               :decimal(, )
#  gst_rate              :decimal(, )
#  gst_rate_updated_when :datetime
#  created_by            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class SpEntryItem < ApplicationRecord
end
