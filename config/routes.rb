Rails.application.routes.draw do
  get 'users/create'

  get 'users/update'

  get 'users/show'

  get 'users/login'

  get 'users/logout'

  namespace :v1 do
    resources :checklists, format: :json do
      resources :items
    end
  end
end
