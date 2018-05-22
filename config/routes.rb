Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  namespace :v1 do

    post "login", controller: 'users', action: :login
    post "otp", controller: 'users', action: :otp
    get "ledger_headings/:transaction_type", controller: 'ledger_headings', action: :index

    resources :users
    resources :ledger_headings, only: [:index]
    resources :banks, only: [:index]

    resources :organisations do
      resources :org_bank_accounts
      resources :transactions
      member do
        get :balance_summary
        get :org_bank_accounts
      end
    end

  end
end
