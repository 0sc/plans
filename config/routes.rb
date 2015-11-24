Rails.application.routes.draw do
  apipie
  resources :users, only: :create
  patch "/users", to: "users#update"

  post "/auth/login", to: "users#login"
  get "/auth/logout", to: "users#logout"

  namespace :v1 do
    resources :checklists, format: :json do
      resources :items
    end
  end
end
