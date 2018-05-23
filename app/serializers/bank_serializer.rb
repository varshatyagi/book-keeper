class BankSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :org_bank_accounts, serializer: OrgBankAccountSerializer
end
