class OrgBankAccountSerializer < ActiveModel::Serializer
  attributes :id, :account_num, :organisation_id, :financial_year

  attributes :bank

  def bank
    return nil unless object.bank_id.present?
    bank = Bank.find(object.bank_id)
    {id: bank.id, name: bank.name}
  end

end
