class AllianceSerializer < ActiveModel::Serializer
  attributes :id, :name, :gstin, :alliance_type, :mob_num, :email
end
