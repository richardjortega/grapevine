Grapevine::Application.routes.draw do
  
  mount StripeEvent::Engine => "/stripe_event"

  devise_for  :users
  resources   :subscriptions
  resources   :blasts,      only: [:show]
  resources   :wantmore,    only: [:show], :controller => 'blasts'

  authenticated :user do
    root to: 'accounts#index'
  end

  root to: 'static_pages#home'
  get '/signup' => 'static_pages#signup',      as: 'signup'

  # Pages and links to be removed once Stripe integration completed
  match '/enroll', to: 'static_pages#enroll'

  match '/concierge', to: 'static_pages#concierge'
  match '/landing', to: 'static_pages#landing'
  match '/landing2', to: 'static_pages#landing2'
  match "hooks" => "hooks#receiver"
  match '/help',  to: 'static_pages#help'

  #Billing/payment page
  # match '/upgrade', to: 'subscriptions#upgrade'

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
  
end
