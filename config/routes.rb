Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  namespace :v1 do
    post "register", controller: 'session', action: :signUp
    post "login", controller: 'session', action: :login
    post "get-otp", controller: 'session', action: :getOtp

    get "ledger-headings/:transaction_type", controller: 'ledger_heading', action: :getLedgerHeadings
    get "ledger-headings", controller: 'ledger_heading', action: :getLedgerHeadings

    get "balance-summary/:orgId", controller: 'organisation', action: :getOrganisationMoneyBalance

    post "transaction/:uid", controller: 'transaction', action: :saveTransaction

    get "organisation/:orgId", controller: 'organisation', action: :organisation
    put "organisation/:orgId", controller: 'organisation', action: :update

    get "banks", controller: 'utility', action: :getBankList
    get "banks/:orgId", controller: 'utility', action: :getOrganisationBanks


  end
end
