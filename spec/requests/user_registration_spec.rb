require 'spec_helper'

describe "user registration" do
	it "allows new users to register with an email address and password" do
		visit "/sign_up"

		fill_in "Email",					:with => "info@pickgrapevine.com"
		fill_in "Password",					:with => "please"
		fill_in "Password confirmation",	:with => "please"

		click_button "Sign up"

		page.should have_content("Welcome! You have signed up successfully.")
	end
end