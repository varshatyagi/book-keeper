Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  namespace :v1 do
    resources :users do
      member do
        post :change_password
      end
    end
    resources :ledger_headings
    resources :banks

    resources :organisations do
      resources :org_bank_accounts
      resources :transactions
      resources :alliances
      resources :cash_transactions
      resources :plans
      member do
        get :balance_summary
        get :reports
        get :plan_info
      end
    end

    post "signup", controller: 'users', action: :signup
    post "login", controller: 'users', action: :login
    post "otp", controller: 'users', action: :otp
    get "states", controller: 'states', action: :index
    get "cities", controller: 'cities', action: :index
    post "forgot_password", controller: 'users', action: :forgot_password
    get "actual_url", controller: 'users', action: :actual_url

  end
end
