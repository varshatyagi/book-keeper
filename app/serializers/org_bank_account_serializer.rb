class OrgBankAccountSerializer < ActiveModel::Serializer
  attributes :id, :bank_balance, :account_num, :organisation_id

  attributes :bank

  def bank
    return nil unless object.bank_id.present?
    bank = Bank.find(object.bank_id)
    {id: bank.id, name: bank.name}
  end

end
