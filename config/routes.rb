Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  namespace :api, defaults: { format: :json }  do
    namespace :v1 do
      post 'sessions/create'
      resources :users, only: %i[create]
      resources :videos, only: %i[index create]
    end
  end
end
