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
      member do
        get :balance_summary
        get :org_bank_accounts
      end
    end

    post "login", controller: 'users', action: :login
    post "otp", controller: 'users', action: :otp
    get "ledger_headings/:transaction_type", controller: 'ledger_headings', action: :index
    post "organisations/:organisation_id/cash_transactions/:type", controller: 'cash_transactions', action: :create

  end
end
