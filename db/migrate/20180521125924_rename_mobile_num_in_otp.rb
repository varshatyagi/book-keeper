class RenameMobileNumInOtp < ActiveRecord::Migration[5.0]
  def change
    rename_column :otps, :mobile_num, :mob_num
  end
end
