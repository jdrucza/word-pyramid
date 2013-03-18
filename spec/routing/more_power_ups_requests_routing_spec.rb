require "spec_helper"

describe MorePowerUpsRequestsController do
  describe "routing" do

    it "routes to #index" do
      get("/more_power_ups_requests").should route_to("more_power_ups_requests#index")
    end

    it "routes to #new" do
      get("/more_power_ups_requests/new").should route_to("more_power_ups_requests#new")
    end

    it "routes to #show" do
      get("/more_power_ups_requests/1").should route_to("more_power_ups_requests#show", :id => "1")
    end

    it "routes to #edit" do
      get("/more_power_ups_requests/1/edit").should route_to("more_power_ups_requests#edit", :id => "1")
    end

    it "routes to #create" do
      post("/more_power_ups_requests").should route_to("more_power_ups_requests#create")
    end

    it "routes to #update" do
      put("/more_power_ups_requests/1").should route_to("more_power_ups_requests#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/more_power_ups_requests/1").should route_to("more_power_ups_requests#destroy", :id => "1")
    end

  end
end
