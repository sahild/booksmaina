Rails.application.routes.draw do
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  resources :books do
    member do
      post :add_to_cart
    end
  end
  resources :authors do
    member do
      get :books
    end
  end
  resources :users
  resources :payments
  resources :plans do
    member do
      post :subscribe
    end
  end
  root "books#index"
  get "about" => "pages#about"
  get "privacy_policy" => "pages#privacy_policy"
  #{|path_params, req| "/authors/#{path_params[:author_name]}" }
  get '/browse_by_author/:author_name' => "authors#findByName"
  get '/browse_by_author', to: redirect('/authors')
  get '/cart' => "carts#show"
  get '/card_details' => "users#card_details"
  post '/card_token' => "users#card_token"
  post '/do_payment' => "users#do_payment"
  get '/choose_card' => "users#choose_card"
  get '/subscriptions' => "users#subscriptions"
  get '/facebook/test' => "facebook#index"
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
