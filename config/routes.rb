Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  namespace :v1 do
    post "register", controller: 'session', action: :sign_up
    post "login", controller: 'session', action: :login
    post "get-otp", controller: 'session', action: :getOtp

    # get "ledger-headings", controller: 'ledger_headings', action: 'index'
    #
    # get "balance-summary/:orgId", controller: 'organisations', action: :getOrganisationMoneyBalance
    #
    # post "transactions/:uid", controller: 'transactions', action: :saveTransaction
    #
    # get "organisations/:orgId", controller: 'organisations', action: :organisation
    # put "organisations/:orgId", controller: 'organisations', action: :update
    #
    # get "banks", controller: 'utility', action: :getBankList
    # get "banks/:orgId", controller: 'utility', action: :getOrganisationBanks

    /users/102.json
    resources :users
    resources :ledger_headings
    resources :banks

    resources :organisations do
      resources :org_bank_accounts
      resources :transactions

      member do
        # organisations/1234/balance_summary.json
        get :balance_summary
      end
    end

  end
end
