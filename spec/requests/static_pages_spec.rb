require 'spec_helper'

describe "Static pages" do

	describe "Home Page" do
		before { visit root_path }

		it "should have in body 'Reviews. Delivered.'" do
			page.should have_content 'Reviews. Delivered.'
		end

		it "should have a title content of 'Grapevine" do
			page.should have_selector 'title', text: 'Grapevine'
		end

	end
end
