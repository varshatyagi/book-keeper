class CashTransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :txn_date, :org_bank_account_id, :remarks

  def amount
    object.amount.to_f
  end

  def txn_date
    object.txn_date.strftime('%m/%d/%Y')
  end

end
