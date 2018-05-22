class OrgBankAccountSerializer < ActiveModel::Serializer
  attributes :id, :organisation_id, :bank, :account_num, :transaction, :bank_balance
end
