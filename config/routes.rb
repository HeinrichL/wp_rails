RailsStarter::Application.routes.draw do
  get "default/welcome"

  post "/posts/create"
  post "/routes/add" => "routes#add_group"
  get "/backend/rest/address/:address" => "backend#address"
  get "/backend/rest/:action" => "backend#:action"
  post "/backend/rest/:action" => "backend#:action"
  get "/routes/search" => "routes#search"
  get "/routes/show/:id" => "routes#show"
  resources :routes
  
  get '/groups/search' => 'groups#search'
  get '/users/search' => 'users#search'
  resources :groups

  get '/users/logout' => 'users#logout'
  get '/users/login' => 'users#login'
  post '/users/login' => 'users#authenticate'
  resources :users


  resources :profiles

  get ':controller(/:action(/:id))'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  
  root :to => 'default#welcome'

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
