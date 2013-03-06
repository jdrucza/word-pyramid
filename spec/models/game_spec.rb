require 'spec_helper'

describe Game do
  describe "waiting_for_player_two" do
    it "should return all games that do not have a player 2 assigned" do
      game = Game.make!

      Game.waiting_for_player_two.first.should == game
    end
  end
end