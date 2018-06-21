class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :mob_num, :email, :role, :organisation_id, :city, :address
  attributes :state_code, :status, :is_temporary_password

end
