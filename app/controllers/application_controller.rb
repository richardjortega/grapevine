class ApplicationController < ActionController::Base
  protect_from_forgery

  # Tell Devise to redirect after sign_out
  def after_sign_out_path_for(resource_or_scope)
    root_url(:protocol => 'http', :notice => 'Successfully signed out. Thank you.')
  end

  private
  

end
