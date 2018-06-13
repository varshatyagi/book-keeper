class OrgBalanceSerializer < ActiveModel::Serializer
  attributes :id, :organisation_id, :financial_year_start
  attributes :cash_opening_balance, :bank_opening_balance, :credit_opening_balance, :cash_balance
  attributes :credit_balance, :bank_balance, :debit_balance, :debit_opening_balance


  def cash_opening_balance
    object.cash_opening_balance.to_f
  end

  def bank_opening_balance
    object.bank_opening_balance.to_f
  end

  def credit_opening_balance
    object.credit_opening_balance.to_f
  end

  def cash_balance
    object.cash_balance.to_f
  end

  def credit_balance
    object.credit_balance.to_f
  end

  def bank_balance
    object.bank_balance.to_f
  end

  def debit_balance
    object.debit_balance.to_f
  end

  def debit_opening_balance
    object.debit_opening_balance.to_f
  end

end
