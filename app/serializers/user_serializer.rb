class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :mob_num, :email, :token, :role, :organisation_id, :city, :address
  # attributes :state_name, :city, :address

  # def state_name
  #   return nil if state_code.blank?
  #   State.find_by(state_code: state_code).name
  # end

end
