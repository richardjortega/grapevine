require "spec_helper"

describe "user sign in" do
	it "allows users to sign in after they have registered" do
		user = User.create(:email		=> "amber@pickgrapevine.com",
						   :password	=> "please" )

		visit "/sign_in"

		fill_in "Email",	:with => "amber@pickgrapevine.com"
		fill_in "Password", :with => "please"

		click_button "Sign in"

		page.should have_content("Signed in successfully.")
	end

end