class ApplicationController < ActionController::Base
	protect_from_forgery

	private
	# Tell Devise to redirect after sign_out

	### Record a signout
	def after_sign_out_path_for(resource_or_scope)
		kiss_record "Signed Out"
  		new_user_session_path
		#root_url(:protocol => 'http')
	end

	### Record a signin
	def after_sign_in_path_for(resource_or_scope)
	    kiss_identify resource_or_scope.email unless resource_or_scope.email.nil?
	    kiss_record "Signed In"
	    scope = Devise::Mapping.find_scope!(resource_or_scope)
	    home_path = "#{scope}_root_path"
	    respond_to?(home_path, true) ? send(home_path) : root_path
	end
end
