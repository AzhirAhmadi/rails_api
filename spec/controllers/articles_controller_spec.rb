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
            articles = create_list :article, size
            subject
            expect(json_data.length).to eq(size)

            articles.each_with_index do |article, index|
                expect(json_data[index]["attributes"]).to eq({
                    "title" => article.title,
                    "content" => article.content,
                    "slug" => article.slug
                })
            end
        end
    end
end
