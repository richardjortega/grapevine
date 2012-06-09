FactoryGirl.define do
	factory :user do
		name 'Richard Ortega'
		email 'richard@pickgrapevine.com'
		password 'please'
		password_confirmation 'please'
		# if using Devise Confirmable (we aren't)
		# confirmed_at Time.now
	end
end
