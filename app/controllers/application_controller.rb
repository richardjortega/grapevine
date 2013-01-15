class ApplicationController < ActionController::Base
	protect_from_forgery

	# Tell Devise to redirect after sign_out
	def after_sign_out_path_for(resource_or_scope)
	root_url(:protocol => 'http')
	end

	def call_rake(task, options = {})
		options[:rails_env] ||= Rails.env
		args = options.map { |n, v| "#{n.to_s.upcase}='#{v}'" }
		system "rake #{task} #{args.join(' ')} --trace 2>&1 >> #{Rails.root}/log/rake.log &"
	end

	private
  

end
