require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
    describe "#index" do
        subject {get :index}

        it "should return success response" do
            subject
            expect(response).to have_http_status(:ok)
        end

        it "should return proper json" do
            size = 2
            create_list :article, size
            subject
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
            subject
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
end
