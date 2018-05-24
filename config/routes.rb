Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  namespace :v1 do
    resources :users
    resources :ledger_headings
    resources :banks

    resources :organisations do
      resources :org_bank_accounts
      resources :transactions
      resources :alliances
      resources :cash_transactions
      member do
        get :balance_summary
      end
    end

    post "login", controller: 'users', action: :login
    post "otp", controller: 'users', action: :otp
    # post "organisations/:organisation_id/cash_transactions/:type", controller: 'cash_transactions', action: :create

  end
end
