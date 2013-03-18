require 'spec_helper'

describe "MorePowerUpsRequests" do
  describe "GET /more_power_ups_requests" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get more_power_ups_requests_path
      response.status.should be(200)
    end
  end
end
