class CitySerializer < ActiveModel::Serializer
  attributes :state_code, :name, :state_name

  def state_name
    return nil if object.state_code.blank?
    state_name = State.find_by(code: object.state_code)
    state_name.name
  end
end
