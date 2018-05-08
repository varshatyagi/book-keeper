Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  namespace :v1 do
    # resources :session, only: [:create, :destroy]
    post "register", to: "session#signUp"
    post "login", to: "session#loginViaEmail"
    get "session/:uid", to: "session#ifSessionExist"
    # delete "session/:id" to: "session#logout"

  end
end
