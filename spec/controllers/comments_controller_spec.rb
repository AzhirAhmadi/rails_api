require 'rails_helper'
RSpec.describe CommentsController, type: :controller do
  let(:article){create :article}
  describe "#index" do
    it "returns a success response" do
      get :index, params: { article_id: article.id}
      expect(response).to have_http_status(:ok)
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
