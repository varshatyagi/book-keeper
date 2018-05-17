class RenameOtpTable < ActiveRecord::Migration[5.0]
  def change
    rename_column :otps, :message, :otp_pin
  end
end
