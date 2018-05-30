class AddIndexesOtp < ActiveRecord::Migration[5.0]
  def change
    add_index :otps, [:mob_num, :otp_pin], unique: true
  end
end
