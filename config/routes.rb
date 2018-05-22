Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  namespace :v1 do
    # get "balance-summary/:orgId", controller: 'organisations', action: :getOrganisationMoneyBalance
    #
    # post "transactions/:uid", controller: 'transactions', action: :saveTransaction
    #
    # get "organisations/:orgId", controller: 'organisations', action: :organisation
    # put "organisations/:orgId", controller: 'organisations', action: :update
    #
    # get "banks", controller: 'utility', action: :getBankList
    # get "banks/:orgId", controller: 'utility', action: :getOrganisationBanks

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
      end
    end

  end
end
