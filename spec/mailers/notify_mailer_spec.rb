require "spec_helper"

describe NotifyMailer do
  describe "paid_signup" do
    let(:mail) { NotifyMailer.paid_signup }

    it "renders the headers" do
      mail.subject.should eq("Signup")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end
 
    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "account_matched_alert" do
    let(:user) { User.new(first_name: "John", last_name: "Doe", email: "john@example.com") }
    let(:location) do
      Location.new(
        name: "Test Restaurant",
        street_address: "123 Main St",
        city: "San Francisco",
        state: "CA",
        zip: "94102"
      )
    end
    let(:source_name) { "yelp" }
    let(:source_location_uri) { "test-restaurant-san-francisco" }
    let(:mail) { NotifyMailer.account_matched_alert(location, source_name, source_location_uri) }

    before do
      location.stub(:users).and_return([user])
    end

    it "renders the headers" do
      mail.subject.should eq("New Account Matched: Test Restaurant to Yelp")
      mail.to.should eq(["erik@pickgrapevine.com"])
      mail.from.should eq(["alerts@pickgrapevine.com"])
    end

    it "renders the body with location information" do
      mail.body.encoded.should match("Test Restaurant")
      mail.body.encoded.should match("Yelp")
      mail.body.encoded.should match("test-restaurant-san-francisco")
    end

    it "includes user information when user exists" do
      mail.body.encoded.should match("John Doe")
      mail.body.encoded.should match("john@example.com")
    end
  end

end
