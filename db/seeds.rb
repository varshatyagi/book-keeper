# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

#### LedgerHeading seed data ####
# LedgerHeading.create(name: 'Sales', revenue: 1, transcation_type: 'credit' , asset: 0)
# LedgerHeading.create(name: 'Commission', revenue: 1, transcation_type: 'credit' , asset: 0)
# LedgerHeading.create(name: 'Salaries', revenue: 1, transcation_type: 'debit' , asset: 0)
# LedgerHeading.create(name: 'House', revenue: 0, transcation_type: 'credit' , asset: 1)
# LedgerHeading.create(name: 'Car', revenue: 0, transcation_type: 'credit' , asset: 1)
# LedgerHeading.create(name: 'Prop Capital', revenue: 0, transcation_type: 'debit' , asset: 1)
# LedgerHeading.create(name: 'Discount', revenue: true, transcation_type: 'debit' , asset: false)
# LedgerHeading.create(name: 'xyz', revenue: true, transcation_type: 'credit' , asset: false)
#### End of LedgerHeading seed data ####

#### Organisation seed data ####
# Organisation.create(name: 'xyzOrg', org_type: nil, address: 'dm tower' , city: "Indore", state_code: "MP", status: "active", created_by: 1, user_id: 1)

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

#### alliance seed data ####
# Alliance.create(name: "John", alliance_type: "creditors")
# Alliance.create(name: "Robert", alliance_type: "debitors")
# Alliance.create(name: "Heena", alliance_type: "creditors")
# Alliance.create(name: "Roncie", alliance_type: "debitors")
# Alliance.create(name: "Shorey", alliance_type: "creditors")
#### End of alliance seed data ####

#### states seed data ####
# State.create(code: "JK", name: "Jammu & Kashmir")
# State.create(code: "HP", name: "Himachal Pradesh")
# State.create(code: "PB", name: "Punjab")
# State.create(code: "CH", name: "Chandigarh")
# State.create(code: "HR", name: "Haryana")
# State.create(code: "UT", name: "Uttarakhand")
# State.create(code: "DL", name: "Delhi")
# State.create(code: "AS", name: "Assam")
# State.create(code: "BR", name: "Bihar")
# State.create(code: "CT", name: "Chhattisgarh")
# State.create(code: "DN", name: "Dadra and Nagar Haveli")
# State.create(code: "DD", name: "Daman and Diu")
# State.create(code: "AN", name: "Andaman and Nicobar Islands")
# State.create(code: "GJ", name: "Gujarat")
# State.create(code: "JH", name: "Jharkhand")
# State.create(code: "KA", name: "Karnataka")
# State.create(code: "KL", name: "Kerala")
# State.create(code: "LD", name: "Lakshadweep")
# State.create(code: "MH", name: "Maharashtra")
# State.create(code: "MN", name: "Manipur")
# State.create(code: "ML", name: "Meghalaya")
#### End of states seed data ####


#### states seed data ####
# City.create(state_code: "MH", name: "Pune")
# City.create(state_code: "MH", name: "Nagpur")
# City.create(state_code: "MH", name: "Thane")
# City.create(state_code: "MH", name: "Nashik")
# City.create(state_code: "MH", name: "Vasia-virar")
# City.create(state_code: "MH", name: "Aurangabad")
# City.create(state_code: "DL", name: "Suleman Nagar")
# City.create(state_code: "DL", name: "Karawal Nagar")
# City.create(state_code: "DL", name: "Nagloi jat")
# City.create(state_code: "DL", name: "Bhasalwa")
# City.create(state_code: "DL", name: "serampore")
# City.create(state_code: "GJ", name: "Mahesana")
# City.create(state_code: "GJ", name: "Gandhinagar")
# City.create(state_code: "GJ", name: "Anand")
# City.create(state_code: "GJ", name: "Morvi")
# City.create(state_code: "GJ", name: "Surendranagar Dudhrej")
# City.create(state_code: "GJ", name: "Ahmedabad")
# City.create(state_code: "MP", name: "Indore")
# City.create(state_code: "MP", name: "Gwalior")
# City.create(state_code: "MP", name: "Bhopal")
#### End of states seed data ####
