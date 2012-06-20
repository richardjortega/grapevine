class RegistrationsController < Devise::RegistrationsController
	def new
		super
	end

	def create
		super
		puts "hello i can still execute"
	end

	def update
		super
	end

	protected

	def after_sign_up_path_for(resource)
		redirect_to user_path
	end
end
