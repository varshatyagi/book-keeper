Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  namespace :v1 do
    post "register", controller: 'session', action: :signUp
    post "login", controller: 'session', action: :loginViaEmail
    post "session/:uid", controller: 'session', action: :ifSessionExist

    get "ledger-headings/:transaction_type", controller: 'ledger_heading', action: :getLedgerHeadings
    get "ledger-headings", controller: 'ledger_heading', action: :getLedgerHeadings

    get "balance-summary/:orgId", controller: 'organisation', action: :getOrganisationMoneyBalance

    post "transaction/:uid", controller: 'transaction', action: :saveTransaction

    get "organisation/:orgId", controller: 'organisation', action: :organisation

  end
end
