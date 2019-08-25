require 'rails_helper'

RSpec.describe AccessTokensController, type: :controller do
    describe "POST #create" do
        context "when no code provided" do
            subject {post :create}
            it_behaves_like "unauthorized_requests"
        end

        context "when invalid code provided" do
            let(:authorization_error) {
                double("Sawyer::Resource", error: "bad_verification_code")
            }
    
            before do
                allow_any_instance_of(Octokit::Client).to receive(
                    :exchange_code_for_token).and_return(authorization_error)
            end

            subject {post :create, params: { code: "invalid_code" } }
            
            it_behaves_like "unauthorized_requests"
        end

        context "when success request" do
            it "should return 201 status code" do
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

                post :create, params: {code: "valid_code "}

                expect(response).to have_http_status(:created)
            end

            it "should return proper json body" do
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

                
                expect{ post :create, params: {code: "valid_code "} }.to change{ User.count }.by(1)

                user = User.find_by( login: "jsmith1" )

                expect(json_data["attributes"]).to eq({"token" => user.access_token.token})
            end
        end
    end

    describe "DELETE #destroy" do
        context "when invalid requeset" do
            let(:authorization_error) do
                {
                    "status" => 403,
                    "source" => { "pointer" => "/code" },
                    "title" => "Authentication code is invalid",
                    "detail" => "You must provide valid code in order to exchange it for token."
                }
            end
            
            it "should return 403 status code" do
                pending
                subject
                expect(response).to have_http_status(:forbidden)
            end

            it "should return proper error json" do
                pending

                authorization_error = {
                    "status" => 403,
                    "source" => { "pointer" => "/code" },
                    "title" => "Authentication code is invalid",
                    "detail" => "You must provide valid code in order to exchange it for token."
                }
                subject
                expect(json["error"]).to eq(authorization_error)
            end

        end

        context "when valid request" do

        end
    end
end
