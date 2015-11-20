Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :checklists, format: :json do
        resources :items
      end
    end
  end
end
