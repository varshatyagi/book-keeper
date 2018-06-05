class OrganisationSerializer < ActiveModel::Serializer
  attributes :id, :name, :owner_id, :created_by, :owner, :org_balance_id

  def owner
    return nil if object.id.blank?
    user = User.find_by(organisation_id: object.id)
    {id: user.id, name: user.name, mob_num: user.mob_num, email: user.email, role: user.role, city: user.city, state: user.state_code}
  end
end
