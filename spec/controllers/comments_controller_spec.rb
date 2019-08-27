require 'rails_helper'
RSpec.describe CommentsController, type: :controller do
  let(:article){create :article}
  describe "#index" do
    subject{ get :index, params: { article_id: article.id} }

    it "returns a success response" do
      expect(response).to have_http_status(:ok)
    end

    it "should return only comments belonging to article" do
      comment = create :comment, article: article
      create :comment
      subject
      expect(json_data.length).to eq(1)
      expect(json_data.first["id"]).to eq(comment.id.to_s)
    end

    it "should paginate results" do
      comments = create_list :comment, 3, article: article
      get :index, params: { article_id: article.id, per_page: 1, page: 2 }
      comment = comments.second
      expect(json_data.length).to eq(1)
      expect(json_data.first["id"]).to eq(comment.id.to_s)
    end

    it "should have proper json body" do
      comment = create :comment, article: article
      subject
      expect(json_data.first["attributes"]).to eq({
        "content" => comment.content
      })
    end

    it "should have related object information in the response" do
      user = create :user
      create :comment, article: article, user: user
      subject
      relationships = json_data.first["relationships"]
      expect(relationships["article"]["data"]["id"]).to eq(article.id.to_s)
      expect(relationships["user"]['data']['id']).to eq(user.id.to_s)

    end
  end

  describe "#create" do
    context "when not authorized" do
      subject{ post :create, params: { article_id: article.id}}

      it_behaves_like "forbidden_requests"
    end

    context "when authorized" do
      let(:user) { create :user }
      let(:access_token) { user.create_access_token }
      before { request.headers["authorization"] = "Bearer #{access_token.token}" }

      context "with invalid params" do
        let(:invalid_attributes) {
          { content: ""}
        }

        subject{ post :create, params: { article_id: article.id, comment: invalid_attributes} }

        it "renders a JSON response with errors for the new comment" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with valid params" do
        let(:valid_attributes) {
          { content: "Content"}
        }
        
        subject{ post :create, params: { article_id: article.id, comment: valid_attributes} }
        
        it "creates a new Comment" do
          expect {subject}.to change(Comment, :count).by(1)
        end

        it "renders a JSON response with the new comment" do
          subject
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq( article_url(article))
        end
      end
    end
  end
end
