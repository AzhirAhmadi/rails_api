require "rails_helper"

describe UserAuthenticator::Oauth do
    describe "#perform" do
        context "when code is incorrect" do
            it "should raise an error" do
                github_error = double("Sawyer::Resource", error: "bad_verification_code")

                allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return(github_error)

                authenticator = described_class.new("sample_code")

                expect{authenticator.perform}.to raise_error(ErrorHandeler::AuthenticationError::Oauth)

                expect(authenticator.user).to be_nil
            end
        end
        
        context "when code is correct" do
            it "should save the user when does not exists" do
                user_data = {
                    login: "jsmith1",
                    url: "http://example.com",
                    avatar_url: "http://example.com/avatar",
                    name: "John Smith"
                }

                allow_any_instance_of(Octokit::Client).to receive(
                    :exchange_code_for_token).and_return("valid_access_token")

                allow_any_instance_of(Octokit::Client).to receive(
                    :user).and_return(user_data)

                authenticator = described_class.new("sample_code")

                expect{authenticator.perform}.to change{ User.count }.by(1)

                expect(User.last.name).to eq("John Smith")
            end

            it "should reuse already ergistered user" do
                user_data = {
                    login: "jsmith1",
                    url: "http://example.com",
                    avatar_url: "http://example.com/avatar",
                    name: "John Smith"
                }

                allow_any_instance_of(Octokit::Client).to receive(
                    :exchange_code_for_token).and_return("valid_access_token")

                allow_any_instance_of(Octokit::Client).to receive(
                    :user).and_return(user_data)

                authenticator = described_class.new("sample_code")

                user = create :user, user_data
                               
                expect{ authenticator.perform }.not_to change{User.count}

                expect( authenticator.user ).to eq(user)
            end
        end
    end
end
    
        