require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
    describe "#index" do

        it "should return success response" do
            get :index
            expect(response).to have_http_status(:ok)
        end

        it "should return proper json" do
            size = 2
            create_list :article, size
            get :index
            expect(json_data.length).to eq(size)

            Article.recent.each_with_index do |article, index|
                expect(json_data[index]["attributes"]).to eq({
                    "title" => article.title,
                    "content" => article.content,
                    "slug" => article.slug
                })
            end
        end

        it "should return articles in proper order" do
            old_article = create :article
            newer_article = create :article
            get :index
            expect(json_data.first["id"]).to eq(newer_article.id.to_s)
            expect(json_data.last["id"]).to eq(old_article.id.to_s)
        end

        it "should paginate results" do
            create_list :article, 3
            get :index, params: {page: 2, per_page: 1}
            expect(json_data.length).to eq 1
            expect(json_data.first["id"]).to eq(Article.recent.second.id.to_s)
        end
    end
    describe "#show" do
        let(:article) { create :article}
        subject { get :show, params: { id: article.id } }

        it "should return success response" do
            subject
            expect(response).to have_http_status(:ok)
        end

        it "should return proper json" do
            subject

            expect(json_data["attributes"]).to eq({
                "title" => article.title,
                "content" => article.content,
                "slug" => article.slug
            })
        end
    end
    describe "#create" do
        subject { post :create }
    
        context "when no code provided" do
          it_behaves_like "forbidden_requests"
        end
    
        context "when invalid code provided" do
          before { request.headers["authorization"] = "Invalid token" }
          it_behaves_like "forbidden_requests"
        end 

        context "when authorized" do
            let(:access_token) { create :access_token}
            before { request.headers["authorization"] = "Bearer #{access_token.token}" }

            context "and invalid parameters provided" do
                let(:invalid_attributes) do
                    {
                        "data" => {
                            "attributes" => {
                                "title" => "",
                                "content" => "",
                                "slug" => ""
                            }
                        }
                    }
                end
                subject { post :create, params: invalid_attributes }

                it "should return 422 status code" do
                    subject
                    expect(response).to have_http_status(:unprocessable_entity)
                end

                it "should return proper error json" do
                    subject
                    expect(json["errors"]).to include(
                        {
                            "source" => { "pointer" => "/data/attributes/title" },
                            "detail" =>  "can't be blank"
                        },
                        {
                            "source" => { "pointer" => "/data/attributes/content" },
                            "detail" =>  "can't be blank"
                        },
                        {
                            "source" => { "pointer" => "/data/attributes/slug" },
                            "detail" =>  "can't be blank"
                        }
                        )
                end
            end

            context "and success request sent" do
                before { request.headers["authorization"] = "Bearer #{access_token.token}" }

                let(:valid_attributes) do
                    {
                        "data" => {
                            "attributes" => {
                                "title" => "Title",
                                "content" => "Content",
                                "slug" => "slug-1"
                            }
                        }
                    }
                end

                subject { post :create, params: valid_attributes }

                it "should have 201 status code" do
                    pp request.headers
                    subject
                    expect(response).to have_http_status(:created)
                end

                it "should have proper json body" do
                    subject
                    expect(json_data["attributes"]).to include(valid_attributes["data"]["attributes"])
                end

                it "should create the article" do
                    expect{ subject }.to change{ Article.count }.by(1)
                end

            end
        end
    end  
    describe "#update" do
        let(:user) { create :user }
        let(:article) { create :article, user: user}
        let(:access_token) { user.create_access_token}

        subject { patch :update, params: { id: article.id } }
    
        context "when no code provided" do
          it_behaves_like "forbidden_requests"
        end
    
        context "when invalid code provided" do
          before { request.headers["authorization"] = "Invalid token" }
          it_behaves_like "forbidden_requests"
        end 

        context "when tring to update not owend article" do
            let(:other_user) { create :user}
            let(:other_article) { create :article, user: other_user}
            subject {patch :update, params: { id: other_article.id } }
            before { request.headers["authorization"] = "Bearer #{access_token}" } 

            it_behaves_like "forbidden_requests"
        end

        context "when authorized" do
            before { request.headers["authorization"] = "Bearer #{access_token.token}" }

            context "and invalid parameters provided" do
                let(:invalid_attributes) do
                    {   "id" => article.id,
                        "data" => {
                            "attributes" => {
                                "title" => "",
                                "content" => "",
                                "slug" => ""
                            }
                        }
                    }
                end
                subject { put :update, params: invalid_attributes }

                it "should return 422 status code" do
                    subject
                    expect(response).to have_http_status(:unprocessable_entity)
                end

                it "should return proper error json" do
                    subject
                    expect(json["errors"]).to include(
                        {
                            "source" => { "pointer" => "/data/attributes/title" },
                            "detail" =>  "can't be blank"
                        },
                        {
                            "source" => { "pointer" => "/data/attributes/content" },
                            "detail" =>  "can't be blank"
                        },
                        {
                            "source" => { "pointer" => "/data/attributes/slug" },
                            "detail" =>  "can't be blank"
                        }
                        )
                end
            end

            context "and success request sent" do
                before { request.headers["authorization"] = "Bearer #{access_token.token}" }

                let(:valid_attributes) do
                    {   "id" => article.id,
                        "data" => {
                            "attributes" => {
                                "title" => "NewTitle",
                                "content" => "NewContent",
                                "slug" => "NewSlug-1"
                            }
                        }
                    }
                end
                subject { put :update, params: valid_attributes }

                it "should have 200 status code" do
                    subject
                    expect(response).to have_http_status(:ok)
                end

                it "should have proper json body" do
                    subject
                    expect(json_data["attributes"]).to include(valid_attributes["data"]["attributes"])
                end

                it "should create the article" do
                    subject
                    # expect(json_data["attributes"]["title"]).not_to eq(article.title)
                    expect(article.reload.title).to eq(json_data["attributes"]["title"])
                end

            end
        end
    end
    describe "#destroy" do
        let(:user) { create :user }
        let(:article) { create :article, user: user}
        let(:access_token) { user.create_access_token}

        subject { delete :destroy, params: { id: article.id } }
    
        context "when no code provided" do
          it_behaves_like "forbidden_requests"
        end
    
        context "when invalid code provided" do
          before { request.headers["authorization"] = "Invalid token" }
          it_behaves_like "forbidden_requests"
        end 

        context "when tring to destroy not owend article" do
            let(:other_user) { create :user}
            let(:other_article) { create :article, user: other_user}
            subject { delete :destroy, params: { id: other_article.id } }
            before { request.headers["authorization"] = "Bearer #{access_token}" } 

            it_behaves_like "forbidden_requests"
        end

        context "when authorized" do
            context "and success request sent" do
                before { request.headers["authorization"] = "Bearer #{access_token.token}" }

                subject { delete :destroy, params: { id: article.id } }

                it "should have 204 status code" do
                    subject
                    expect(response).to have_http_status(:no_content)
                end
                
                it "should have empty json body" do
                    subject
                    expect(response.body).to be_blank
                end

                it "should destroy the article" do
                    article
                    expect{ subject }.to change{ user.articles.count }.by(-1)
                end
            end
        end
    end

 end
