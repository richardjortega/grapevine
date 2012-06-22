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

end
