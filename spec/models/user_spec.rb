require 'spec_helper'

describe User do

	before(:each) do
		@user = FactoryGirl.build(:user)
	end

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:remember_token) }

	it { should be_valid }

end