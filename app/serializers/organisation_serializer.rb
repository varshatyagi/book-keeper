class OrganisationSerializer < ActiveModel::Serializer
  attributes :id, :name, :owner_id, :created_by
end
