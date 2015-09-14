Rails.application.routes.draw do
   
    get 'login' => 'admin#login_form'
    post 'login' => 'admin#login'
    get 'logout' => 'admin#logout'
    
    get 'tasks/new' => 'tasks#new'
    post 'tasks' => 'tasks#create'
    get 'tasks/queue' => 'tasks#queue'
    post 'tasks/initial' => 'tasks#initial'
    get 'tasks/:id/edit' => 'tasks#edit'
    patch 'tasks/:id' => 'tasks#update'
    post 'tasks/destroy' => 'tasks#destroy'
    get 'tasks/history' => 'tasks#history'
    get 'tasks/all' => 'tasks#all'
    post 'tasks/received_by' => 'tasks#received_by'
    
    get 'comments' => 'comments#list'
    post 'comments' => 'comments#create'
    
    get 'playgolf20142014/normalize_attributes' => 'admin#normalize_attributes'
    get 'playgolf20142014/test' => 'admin#test'
    get 'playgolf20142014/fixtures' => 'admin#fixtures'
    get 'playgolf20142014/reset' => 'admin#reset'
    
    root 'admin#login_form'

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
