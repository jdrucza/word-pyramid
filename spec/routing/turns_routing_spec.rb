require "spec_helper"

describe TurnsController do
  describe "routing" do

    it "routes to #index" do
      get("/games/1/turns").should route_to("turns#index", :game_id => "1")
    end

    it "routes to #new" do
      get("/games/1/turns/new").should route_to("turns#new", :game_id => "1")
    end

    it "routes to #show" do
      get("/games/1/turns/1").should route_to("turns#show", :id => "1", :game_id => "1")
    end

    it "routes to #edit" do
      get("/games/1/turns/1/edit").should route_to("turns#edit", :id => "1", :game_id => "1")
    end

    it "routes to #create" do
      post("/games/1/turns").should route_to("turns#create", :game_id => "1")
    end

    it "routes to #update" do
      put("/games/1/turns/1").should route_to("turns#update", :id => "1", :game_id => "1")
    end

    it "routes to #destroy" do
      delete("/games/1/turns/1").should route_to("turns#destroy", :id => "1", :game_id => "1")
    end

  end
end
