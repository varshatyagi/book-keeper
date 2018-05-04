Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  namespace :v1 do
    # resources :session, only: [:create, :destroy]
    post "register", to: "session#signUp"
    post "session", to: "session#loginViaEmail"
    # delete "session/:id" to: "session#logout"

  end
end
