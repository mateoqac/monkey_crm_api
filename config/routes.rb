Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/auth/signup', to: 'authentication#signup'
      post '/auth/login', to: 'authentication#login'
      post '/auth/logout', to: 'authentication#logout'
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
