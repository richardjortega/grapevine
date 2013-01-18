class ApplicationController < ActionController::Base
	protect_from_forgery

	private
	# Tell Devise to redirect after sign_out

	### Record a signout
	def after_sign_out_path_for(resource_or_scope)
  		root_url(:protocol => 'http')
	end
end
