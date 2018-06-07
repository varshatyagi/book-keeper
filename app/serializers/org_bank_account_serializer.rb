class OrgBankAccountSerializer < ActiveModel::Serializer
  attributes :id, :account_num, :organisation_id, :financial_year

  attributes :bank, :org_bank_account_summary

  def bank
    return nil unless object.bank_id.present?
    bank = Bank.find(object.bank_id)
    {id: bank.id, name: bank.name}
  end

  def org_bank_account_summary
    return {bank_balance: nil, opening_balance: nil} if object.org_bank_account_balance_summary.blank?
    {bank_balance: object.org_bank_account_balance_summary.bank_balance, opening_balance: object.org_bank_account_balance_summary.opening_balance}
  end

end
