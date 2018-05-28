class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :mob_num, :email, :token, :role, :organisation_id, :city, :address
  attributes :state_code
end
