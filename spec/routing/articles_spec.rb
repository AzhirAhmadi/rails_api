require "rails_helper"

describe "articles routes" do
    it "should rout to articles index" do
        expect(get "/articles").to route_to("articles#index")
    end

    it "should rout to articles show" do
        expect(get "/articles/1").to route_to("articles#show", id: "1")
    end

    it "should route to articles create" do
        expect(post "/articles").to route_to("articles#create")
    end

    it "should route to articles update" do
        expect(put "/articles/1").to route_to("articles#update", id: "1")
        expect(patch "/articles/1").to route_to("articles#update", id: "1")
    end

    it "should route to articles destroy" do
        expect(delete "/articles/1").to route_to("articles#destroy", id: "1")
    end
end
