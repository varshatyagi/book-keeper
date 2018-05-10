Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  namespace :v1 do
    post "register", controller: 'session', action: :signUp
    post "login", controller: 'session', action: :loginViaEmail
    post "session/:uid", controller: 'session', action: :ifSessionExist

    get "ledger-headings/:type", controller: 'ledger_heading', action: :getLedgerHeadings
    get "ledger-headings", controller: 'ledger_heading', action: :getLedgerHeadings

    # delete "session/:id" to: "session#logout"
    # get "ledger-heading/:type", to: "ledgerHeading#getLedgerHeadings"

  end
end
