require "rails_helper"

describe RegistrationsController do
    describe "#create" do
        subject { post :create, params: params}

        context "when invalid data provided" do
            let(:params) do
                {
                    "data" => {
                        "attributes" => {
                            "login" => nil,
                            "password" => nil
                        }
                    }
                }
            end
            it "should return unprocessable_entity status code" do
                subject
                expect(response).to have_http_status(:unprocessable_entity)
            end

            it "should not create a user" do
                expect{subject}.not_to change{ User.count}
            end

            it "shloud retrun error messages in response body" do
                subject

                expect(json["errors"]).to include(
                    {
                        "source" => { "pointer" => "/data/attributes/login"},
                        "detail" => "can't be blank"
                    },
                    {
                        "source" => { "pointer" => "/data/attributes/password"},
                        "detail" => "can't be blank"
                    }
                )
            end
        end

        context "when valid data provided" do
            let(:params) do
                {
                    "data" => {
                        "attributes" => {
                            "login" => "jsmith",
                            "password" => "secret"
                        }
                    }
                }
            end
            it "should return 201 http status code" do
                subject
                expect(response).to have_http_status(:created)
            end

            it "shloud create a user" do
                expect(User.exists?(login: params["data"]["attributes"]["login"])).to be_falsey
                expect{subject}.to change{ User.count}.by(1)
                expect(User.exists?(login: params["data"]["attributes"]["login"])).to be_truthy
            end
        end
    end
end