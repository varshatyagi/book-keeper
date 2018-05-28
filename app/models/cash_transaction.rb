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
#  organisation_id     :integer
#

class CashTransaction < ApplicationRecord
  belongs_to :organisation, optional: true
  belongs_to :org_bank_account, optional: true

  after_create :update_balance

  def update_balance
    if withdrawal?
      org_bank_account.bank_balance -= amount
      organisation.org_balance.cash_balance += amount
      organisation.org_balance.bank_balance -= amount
    else
      org_bank_account.bank_balance += amount
      organisation.org_balance.cash_balance -= amount
      organisation.org_balance.bank_balance += amount
    end

    org_bank_account.save!
    organisation.org_balance.save!
  end
end
