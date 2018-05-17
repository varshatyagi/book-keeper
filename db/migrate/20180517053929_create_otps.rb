class CreateOtps < ActiveRecord::Migration[5.0]
  def change
    create_table :otps do |t|
      t.string "mobile_num", :uniqueness => true
      t.string "message"
      t.datetime "created_at"
    end
  end
end
