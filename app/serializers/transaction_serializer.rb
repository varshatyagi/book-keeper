class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :ledger_heading, :amount, :remarks, :payment_mode, :txn_date
  attributes :organisation_id, :alliance_id, :org_bank_account_id

  def amount
    object.amount.to_f
  end

  def txn_date
    object.txn_date.strftime('%m/%d/%Y')
  end
  def ledger_heading
    ledger_heading = LedgerHeading.find(object.ledger_heading_id)
    ledger_heading
  end
end
