require "spec_helper"

describe NotifyMailer do
  describe "signup" do
    let(:mail) { NotifyMailer.signup }

    it "renders the headers" do
      mail.subject.should eq("Signup")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
