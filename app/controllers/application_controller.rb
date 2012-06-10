class ApplicationController < ActionController::Base
  protect_from_forgery

  # Helpers from Devise
  # To add user authentication add 'before_filter :authenticate_user!'
  # Verify if signed in - user_signed_in?
  # Current signed in user - current_user
  # Access session for this scope - user_session

  private

  # do i even need this... damn will find out while refactoring
  def require_user
  	redirect_to root_path unless current_user
  end
end
