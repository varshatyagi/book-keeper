# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

#### LedgerHeading seed data ####
LedgerHeading.create(name: 'Sales', revenue: 1, transcation_type: 'credit' , asset: 0)
LedgerHeading.create(name: 'Commission', revenue: 1, transcation_type: 'credit' , asset: 0)
LedgerHeading.create(name: 'Salaries', revenue: 1, transcation_type: 'debit' , asset: 0)
LedgerHeading.create(name: 'House', revenue: 0, transcation_type: 'credit' , asset: 1)
LedgerHeading.create(name: 'Car', revenue: 0, transcation_type: 'credit' , asset: 1)
LedgerHeading.create(name: 'Prop Capital', revenue: 0, transcation_type: 'debit' , asset: 1)
LedgerHeading.create(name: 'Discount', revenue: true, transcation_type: 'debit' , asset: false)
LedgerHeading.create(name: 'xyz', revenue: true, transcation_type: 'credit' , asset: false)
#### End of LedgerHeading seed data ####

#### Organisation seed data ####
# Organisation.create(name: 'xyzOrg', org_type: nil, address: 'dm tower' , city: "Indore", state_code: "MP", status: "active", created_by: 1, owner_id: 1)
#### End of Organisation seed data ####

#### OrgBalance seed data ####
# OrgBalance.create(org_id: 1, cash_opening_balance: 23452, bank_opening_balance: 235678 , credit_opening_balance: 50000, financial_year_start: Time.now, cash_balance: 23452, bank_balance: 235678, credit_balance: 50000)
# OrgBalance.create(org_id: 2, cash_opening_balance: 23452, bank_opening_balance: 235678 , credit_opening_balance: 50000, financial_year_start: Time.now, cash_balance: 23452, bank_balance: 235678, credit_balance: 50000)
# OrgBalance.create(org_id: 3, cash_opening_balance: 23452, bank_opening_balance: 235678 , credit_opening_balance: 50000, financial_year_start: Time.now, cash_balance: 23452, bank_balance: 235678, credit_balance: 50000)
# OrgBalance.create(org_id: 4, cash_opening_balance: 23452, bank_opening_balance: 235678 , credit_opening_balance: 50000, financial_year_start: Time.now, cash_balance: 23452, bank_balance: 235678, credit_balance: 50000)
#### End of OrgBalance seed data ####

#### OrgBankAccount seed data ####
# OrgBankAccount.create(org_id: 1, bank_id: 1, account_num: "00440532013000" , bank_balance: 50000, deleted: false)
# OrgBankAccount.create(org_id: 1, bank_id: 2, account_num: "00440532013001" , bank_balance: 60000, deleted: false)
# OrgBankAccount.create(org_id: 1, bank_id: 3, account_num: "00440532013002" , bank_balance: 70000, deleted: false)
#### End of OrgBankAccount seed data ####

#### Bank seed data ####
# Bank.create(name: "State Bank Of India")
# Bank.create(name: "ICICI Bank")
# Bank.create(name: "Bank Of India")
# Bank.create(name: "Corporation Bank")
# Bank.create(name: "Oriental Bank")
#### End of Bank seed data ####
