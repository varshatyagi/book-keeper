Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  namespace :v1 do
    resources :users
    resources :ledger_headings, only: [:index]
    resources :banks, only: [:index]

    resources :organisations do
      resources :org_bank_accounts
      resources :transactions
      resources :alliances
      resources :cash_transactions
    end

    post "login", controller: 'users', action: :login
    post "otp", controller: 'users', action: :otp
    get "ledger_headings/:transaction_type", controller: 'ledger_headings', action: :index
    post "organisations/:organisation_id/cash_transactions/:type", controller: 'cash_transactions', action: :create
    get "organisations/:organisation_id/balance_summary", controller: 'org_balances', action: :balance_summary
    get "organisations/:organisation_id/alliances/search/:type", controller: 'alliances', action: :search_by_type
  end
end
