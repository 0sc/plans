Rails.application.routes.draw do
  resources :users, only: :create

  namespace :v1 do
    resources :checklists, format: :json do
      resources :items
    end
  end
end
