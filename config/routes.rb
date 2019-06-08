Rails.application.routes.draw do
  root to: 'v1/stations#index'

  concern :api_base do
    resources :stations, only: [:index]
  end

  namespace :v1 do
    concerns :api_base
  end
end
