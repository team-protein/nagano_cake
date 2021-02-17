Rails.application.routes.draw do
  get '/search' => 'search#search'
  devise_for :admin, controllers: {
    sessions:      'admins/sessions',
  }
  devise_for :customers, controllers: {
    registrations: 'customers/registrations',
    sessions:      'customers/sessions'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "homes#top"
  get "about" => "homes#about"

  resource :customers, only: [:edit, :update]
  get "customers/my_page" => "customers#show"
  get "customers/delete_confirm" => "customers#delete_confirm"
  patch "customers/withdraw" => "customers#withdraw"

  resources :products, only: [:index, :show]

  resources :cart_products, only: [:index, :update, :destroy, :create] do
    collection do
      delete "destroy_all"
    end
  end

  resources :orders, only: [:new, :create, :index, :show] do
    collection do
      post "confirm"
      get "complete"
    end
  end
  resources :addresses, except: [:new, :show]

  namespace :admin do
    resources :customers, only: [:index, :show, :edit, :update]
    resources :products, except: [:destroy]
    resources :genres, only: [:index, :edit, :create, :update]
    resources :orders, only: [:show, :update, :index] do
      resources :ordered_products, only: [:update]
    end
    get '/search' => 'search#search'
  end

end
