class OrgBankAccountSerializer < ActiveModel::Serializer
  attributes :id, :account_num, :organisation_id

  attributes :bank, :org_bank_account_summary

  def bank
    return nil unless object.bank_id.present?
    bank = Bank.find(object.bank_id)
    {id: bank.id, name: bank.name}
  end

  def org_bank_account_summary
    records = OrgBankAccountBalanceSummary.where(org_bank_account_id: object.id)
    return records
    record = object.org_bank_account_balance_summary.acnts_with_financial_year(Common.calulate_financial_year).first
    return {bank_balance: nil, opening_balance: nil} if record.blank?
    {bank_balance: record.bank_balance, opening_balance: record.opening_balance}
  end

end
