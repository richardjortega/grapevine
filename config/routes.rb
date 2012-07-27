Grapevine::Application.routes.draw do
  devise_for :users

  resources :subscriptions

  authenticated :user do
    root to: 'accounts#index'
  end

  root to: 'static_pages#home'

  get '/signup' => 'static_pages#signup',      as: 'signup'

  match '/enroll', to: 'static_pages#enroll'
  match '/demo', to: 'static_pages#demo'
  match "hooks" => "hooks#receiver"
  match '/help',  to: 'static_pages#help'

  # Reconfiguring Devise routes for pretty URLs, because they look pretty!
  # For linking make sure to keep using full default route paths (i.e. - sign_in would be new_user_session_path)
  as :user do
    get 'sign_in' => 'devise/sessions#new', :as => :new_user_session
    post 'sign_in' => 'devise/sessions#create', :as => :user_session
    match 'sign_out' => 'devise/sessions#destroy', :as => :destroy_user_session,
      :via => Devise.mappings[:user].sign_out_via
    # get 'sign_up' => 'devise/registrations#new', :as => :new_user_registration
    get 'edit_profile' => 'devise/registrations#edit', :as => :edit_user_registration
  end

  # default rake routes for devise User
  #         new_user_session GET    /users/sign_in(.:format)       devise/sessions#new
  #             user_session POST   /users/sign_in(.:format)       devise/sessions#create
  #     destroy_user_session DELETE /users/sign_out(.:format)      devise/sessions#destroy
  #            user_password POST   /users/password(.:format)      devise/passwords#create
  #        new_user_password GET    /users/password/new(.:format)  devise/passwords#new
  #       edit_user_password GET    /users/password/edit(.:format) devise/passwords#edit
  #                          PUT    /users/password(.:format)      devise/passwords#update
  # cancel_user_registration GET    /users/cancel(.:format)        devise/registrations#cancel
  #        user_registration POST   /users(.:format)               devise/registrations#create
  #    new_user_registration GET    /users/sign_up(.:format)       devise/registrations#new
  #   edit_user_registration GET    /users/edit(.:format)          devise/registrations#edit
  #                          PUT    /users(.:format)               devise/registrations#update
  #                          DELETE /users(.:format)               devise/registrations#destroy
  



  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

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
