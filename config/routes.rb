Grapevine::Application.routes.draw do
  
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  mount StripeEvent::Engine => "/stripe_event"

  devise_for  :users, :controllers => {:registrations => "registrations"}
  resources   :subscriptions
  resources   :wantmore,    only: [:show], :controller => 'blasts'
  #for testing multiple variations of wantmore page
  get '/wantmore2/:id', to: 'blasts#wantmore2', as: 'wantmore2'
  get '/wantmore3/:id', to: 'blasts#wantmore3', as: 'wantmore3'
  get '/wantmore4/:id', to: 'blasts#wantmore4', as: 'wantmore4'
  get '/wantmore5/:id', to: 'blasts#wantmore5', as: 'wantmore5'
  get '/wantmore6/:id', to: 'blasts#wantmore6', as: 'wantmore6'
  get '/wantmore7/:id', to: 'blasts#wantmore7', as: 'wantmore7'
  get '/wantmore8/:id', to: 'blasts#wantmore8', as: 'wantmore8'
  get '/wantmore8/:id', to: 'blasts#wantmore8', as: 'wantmore9'
  get '/follow_up/:id', to: 'blasts#follow_up', as: 'follow_up'

  authenticated :user do
    root to: 'accounts#index'
    
    #Billing/payment page
    match '/changeplan', to: 'accounts#update', as: 'change_plan'
    match '/billing', to: 'accounts#billing', as: 'billing'
    match '/upgrade', to: 'accounts#update', as: 'upgrade'
  end

  root to: 'static_pages#home'
  

  # deez be my new pages yo
  match '/about', :to => 'static_pages#about', as: 'about'
  match '/signup', :to => 'static_pages#signup', as: 'signup'
  match '/pricing', :to => 'static_pages#pricing', as: 'pricing'
  match '/contact', :to => 'static_pages#contact', as: 'contact'
  match '/learn-more', :to => 'static_pages#learn_more', as: 'learn_more'
  match '/terms', :to => 'static_pages#terms', as: 'terms'
  match '/privacy', :to => 'static_pages#privacy', as: 'privacy'
  post '/static_pages/submit_contact_us', to: 'static_pages#submit_contact_us'



  # some older but relevant shit
  match '/blog', :to => redirect('http://pickgrapevine.tumblr.com')
  match '/thankyou', to: 'static_pages#thankyou'
  match '/help',  to: 'static_pages#help'
  match '/404',  to: 'static_pages#error404'

  # Review posting for Erik
  match '/thor_of_asgard', to: 'static_pages#thor_of_asgard'
  match '/send_follow_up', to: 'static_pages#send_follow_up'
  post '/static_pages/review_alert', to: 'static_pages#review_alert'
  post '/static_pages/follow_up_alert', to: 'static_pages#follow_up_alert'
  

  # Shit we may not use... (double check to for deletion)
  match '/signup2', to: 'static_pages#signup2'
  match '/signuptoday', to: 'static_pages#signuptoday'
  match '/enroll', to: 'static_pages#enroll'
  match '/concierge', to: 'static_pages#concierge'
  match '/upgradetoday', to: 'static_pages#upgradetoday'

 

  # Reconfiguring Devise routes for pretty URLs, because they look pretty!
  # For linking make sure to keep using full default route paths (i.e. - sign_in would be new_user_session_path)
  as :user do
    get 'sign_in' => 'devise/sessions#new', :as => :new_user_session
    post 'sign_in' => 'devise/sessions#create', :as => :user_session
    match 'upgrade' => 'devise/sessions#new', :as => :upgrade
    match 'sign_out' => 'devise/sessions#destroy', :as => :destroy_user_session,
      :via => Devise.mappings[:user].sign_out_via
    get 'profile' => 'registrations#edit', :as => :edit_user_registration
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
