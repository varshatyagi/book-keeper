Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  namespace :v1 do
    # resources :session, only: [:create, :destroy]
    post "register", to: "session#signUp"
    post "login", to: "session#loginViaEmail"
    get "session/:uid", to: "session#ifSessionExist"
    # delete "session/:id" to: "session#logout"
    # get "ledger-heading/:type", to: "ledgerHeading#getLedgerHeadings"
    get "ledger-heading/:type", controller: 'ledger_heading', action: :getLedgerHeadings
    get "ledger-heading", controller: 'ledger_heading', action: :getLedgerHeadings

  end
end
