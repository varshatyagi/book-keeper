class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :ledger_heading_id, :amount, :remarks, :payment_mode, :txn_date
  attributes :organisation_id, :alliance_id

  def amount
    object.amount.to_f
  end

  def txn_date
    object.txn_date.strftime('%m/%d/%Y')
  end
end
