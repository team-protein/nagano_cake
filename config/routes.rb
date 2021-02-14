Rails.application.routes.draw do
  devise_for :admin
  devise_for :customers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "homes#top"
  get "about" => "homes#about"

  resource :customers, only: [:show, :edit, :update]
  get "customers/delete_confirm" => "customers#delete_confirm"
  patch "customers/withdraw" => "customers#withdraw"

  resources :products, only: [:index, :show]

  resources :cart_products, only: [:index, :update, :destroy, :create]
  delete "cart_products/destroy_all" => "cart_products#destroy_all"

  resources :orders, only: [:new, :create, :index, :show]
  post "orders/confirm" => "orders#confirm"
  get "orders/complete" => "orders#complete"

  resources :addresses, except: [:new, :show]

  namespace :admin do
    resources :customers, only: [:index, :show, :edit, :update]
    resources :products, except: [:destroy]
    resources :genres, only: [:index, :edit, :create, :update]
    resources :orders, only: [:show, :update, :index] do
      resources :ordered_products, only: [:update]
    end
  end

end
