Rails.application.routes.draw do
  apipie

  api_version(module: "V1", header: {name: "Accept",
    value: "application/vnd.plans; version=1"},
    path: { value: "v1" }, default: true) do
    resources :bucketlists, format: :json do
      resources :items
    end
    resources :users, only: :create
    patch "/users", to: "users#update"
    post "/auth/login", to: "users#login"
    get "/auth/logout", to: "users#logout"
  end

  api_version(module: "V2", header: {name: "Accept",
    value: "application/vnd.plans; version=2"},
    path: { value: "v2" }) do
    resources :bucketlists, only: [:index, :show],  format: :json do
      resources :items, only: [:index, :show]
    end

    resources :bucketlists, controller: "/v1/bucketlists", except: [:index, :show],  format: :json do
      resources :items, controller: "/v1/items", except: [:index, :show]
    end
  end

  match "*path", to: redirect("/docs"), via: :all
end
