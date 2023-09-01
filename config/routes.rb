Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      get "/markets/search", to: "markets#search"
      get "/markets/:id/nearest_atms", to: "markets#get_atms"

      resources :markets, only: [:index, :show] do 
        resources :vendors, only: [:index]
      end
      resources :vendors, except: [:index, :new]
      resources :market_vendors, only: [:create]
      resource :market_vendors, only: [:destroy]

    end
  end

end
