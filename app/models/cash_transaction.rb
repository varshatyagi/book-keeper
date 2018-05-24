# == Schema Information
#
# Table name: cash_transactions
#
#  id                  :integer          not null, primary key
#  amount              :decimal(, )
#  org_bank_account_id :integer
#  withdrawal          :boolean
#  txn_date            :datetime
#  remarks             :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class CashTransaction < ApplicationRecord
  belongs_to :Organisation
  # after_create :update_balance

  def update_balance
    org_bank_acc = OrgBankAccount.find(self.org_bank_account_id)
    raise 'Organisation Bank account is not present' unless org_bank_acc.present?
    bank_balance = org_bank_acc.bank_balance + self.amount if self.withdrawal == false
    bank_balance = org_bank_acc.bank_balance - self.amount if self.withdrawal == true

    org_bank_acc.bank_balance = bank_balance
    org_bank_acc.save!

    org_balance = OrgBalance.find_by(organisation_id: self.organisation_id)
    raise 'Organisation Bank balance record is not found' unless org_balance.present?

    if self.withdrawal == false
      cash_balance = org_balance.cash_balance - self.amount
      bank_balance = org_balance.bank_balance + self.amount
    elsif self.withdrawal == true
      cash_balance = org_balance.cash_balance + self.amount
      bank_balance = org_balance.bank_balance - self.amount
    end
    org_balance.bank_balance = bank_balance
    org_balance.cash_balance = cash_balance
    org_balance.save!
  end

end
