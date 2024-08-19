# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/auth/signup', to: 'authentication#signup'
      post '/auth/login', to: 'authentication#login'
      post '/auth/logout', to: 'authentication#logout'

      resources :customers, only: %i[index show create update destroy]
      resources :users, only: %i[index show create update destroy] do
        member do
          post :add_admin_role
          post :remove_admin_role
        end
      end
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
