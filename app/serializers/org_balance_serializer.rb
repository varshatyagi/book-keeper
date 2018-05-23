class OrgBalanceSerializer < ActiveModel::Serializer
  attributes :id, :organisation_id, :cash_opening_balance, :bank_opening_balance, :credit_opening_balance,
    :cash_balance, :credit_balance, :bank_balance, :financial_year_start
end
