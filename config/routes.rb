Grapevine::Application.routes.draw do
  
  mount_roboto

  # Grapevine Admin Type Stuff
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config
  mount DjMon::Engine => 'delayed_jobs'

  # For Mail_View
  if Rails.env.development?
    mount MailPreview => 'mail_view'
  end  

  mount StripeEvent::Engine => "/stripe_event"

  devise_for  :users, :controllers => {:registrations => "registrations"}
  resources   :subscriptions
  resources   :wantmore,    only: [:show], :controller => 'blasts'
  resources   :send_to_site, only: [:show], :controller => 'static_pages'

  # Order is important!!! don't  switch around 

  #Account Dashboard pages (for logged in users)
  authenticated :user do
    root to: 'accounts#index'
    match '/changeplan', to: 'accounts#update', as: 'change_plan'
    match '/billing', to: 'accounts#billing', as: 'billing'
    match '/upgrade', to: 'accounts#update', as: 'upgrade'
    match '/upgrade-thank-you', to: 'accounts#upgrade_thank_you', as: 'upgrade_thank_you'
  end

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

  #### End order importance ####

  # Static pages
  match '/about', :to => 'static_pages#about', as: 'about'
  match '/signup', :to => 'static_pages#signup', as: 'signup'
  match '/agency-signup', to: 'static_pages#signup', as: 'agency_signup'
  match '/pricing', :to => 'static_pages#pricing', as: 'pricing'
  match '/contact', :to => 'static_pages#contact', as: 'contact'
  match '/learn-more', :to => 'static_pages#learn_more', as: 'learn_more'
  match '/terms', :to => 'static_pages#terms', as: 'terms'
  match '/privacy', :to => 'static_pages#privacy', as: 'privacy'
  match '/thank-you', :to => 'static_pages#thank_you', as: 'thank_you'
  match '/404',  to: 'static_pages#error404'
  post '/static_pages/submit_contact_us', to: 'static_pages#submit_contact_us'
  match '/blog', :to => redirect('http://pickgrapevine.tumblr.com') 
  match '/signup-now', :to => 'static_pages#signup', as: 'signup_now' 
  get '/send_to_site', :to => 'static_pages#send_to_site', as: 'send_to_site'

  # Landing pages for email blasting (deprecated can be deleted in future)
  get '/wantmore2/:id', to: 'blasts#wantmore_redirect'
  get '/wantmore3/:id', to: 'blasts#wantmore_redirect'
  get '/wantmore4/:id', to: 'blasts#wantmore_redirect'
  get '/wantmore5/:id', to: 'blasts#wantmore_redirect'
  get '/wantmore6/:id', to: 'blasts#wantmore_redirect'
  get '/wantmore7/:id', to: 'blasts#wantmore_redirect'
  get '/wantmore8/:id', to: 'blasts#wantmore_redirect'
  get '/wantmore8/:id', to: 'blasts#wantmore_redirect'
  get '/follow_up/:id', to: 'blasts#follow_up', as: 'follow_up'

  # For Grapevine internal team use
  match '/thor_of_asgard', to: 'static_pages#thor_of_asgard'
  match '/send_follow_up', to: 'static_pages#send_follow_up'
  post '/static_pages/review_alert', to: 'static_pages#review_alert'
  post '/static_pages/follow_up_alert', to: 'static_pages#follow_up_alert'

  # Root page
  root to: 'static_pages#home'

end
