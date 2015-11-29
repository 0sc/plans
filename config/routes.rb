Rails.application.routes.draw do
  # root "test.html"
  apipie
  resources :users, only: :create
  patch "/users", to: "users#update"

  post "/auth/login", to: "users#login"
  get "/auth/logout", to: "users#logout"

  namespace :v1 do
    resources :bucketlists, format: :json do
      resources :items
    end
  end

  match "*path", to: redirect("/docs"), via: :all
end
