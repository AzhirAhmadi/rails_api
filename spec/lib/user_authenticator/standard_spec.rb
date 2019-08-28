require "rails_helper"

describe UserAuthenticator::Standard do
    describe "#perform" do
        let(:authenticator) { described_class.new("jsmith", "password")}
        subject( authenticator.perform)

        shared_examples_for "invalid_authentication" do
            before { user }
            it "should raise an error" do
                expect{subject}.to raise_error(
                    ErrorHandler::UserAuthenticator::Standard
                )
                expect(authenticator.user).to be_nill
            end
        end

        context "when invalid login" do
            let(:user) { create :user, login: "invalid_user", password: "password"}
            it_behaves_like "invalid_authentication"
        end

        context "when invalid password" do
            let(:user) { create :user, login: "jsmith", password: "invalid_password"}
            it_behaves_like "invalid_authentication"
        end

        context "when successed auth" do

        end 
    end
end