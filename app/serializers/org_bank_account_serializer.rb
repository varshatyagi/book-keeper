class OrgBankAccountSerializer < ActiveModel::Serializer
  attributes :id, :bank_id, :bank_balance, :account_num, :organisation_id
end
