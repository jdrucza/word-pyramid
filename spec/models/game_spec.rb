require 'spec_helper'

describe Game do
  describe "waiting_for_player_two" do
    it "should return all games that do not have a player 2 assigned" do
      game = Game.make!

      game.player_one_turn?.should be_true
      Game.waiting_for_player_two.first.should == game

      game.player_two = Player.make!
      game.save!
      Game.waiting_for_player_two.first.should be_nil
    end
  end

  describe "not_being_played_by" do
    #it "should return all games that are note being played by a given player" do
    #  game_one = Game.make!
    #  player = Player.make!
    #  game_one.player_two = player
    #  player.save!
    #  game_one.save!
    #  game_two = Game.make!
    #
    #  puts("-x-x-x-x-x-x-x-x-x-x")
    #  puts("         !!!!!!!!         player.user :" + player.user.inspect)
    #  puts("         !!!!!!!!         game_one.player_two :" + game_one.player_two.inspect)
    #  puts("         !!!!!!!!         game_one.player_one :" + game_one.player_one.inspect)
    #  puts("         !!!!!!!!         game_one :" + game_one.inspect)
    #  puts("         !!!!!!!!         game_two :" + game_two.inspect)
    #  puts("         !!!!!!!!         game_two.player_one :" + game_two.player_one.inspect)
    #
    #  User.all.each { |u| Game.not_being_played_by(u).first.should_not be_nil }
    #
    #  #Game.not_being_played_by(player.user).first.should eq(game_two)
    #  #Game.not_being_played_by(game_two.player_one.user).first.should eq(game_one)
    #  #Game.all.should include(game_one)
    #  #Game.all.should include(game_two)
    #end
  end

  describe "join new" do
    it "should assign the specified user as player two" do
      game = Game.make!
      player_two_user = User.make!
      game.player_one.user.should_not eq(player_two_user)
      Game.should_receive(:not_being_played_by).and_return([game])
      Game.join_new(player_two_user).should eq(game)
      game.reload
      game.player_two.user.should eq(player_two_user)
    end
  end

  describe "players_turn?" do
    it "should be true for player one when game state is player_one_turn" do
      game = Game.make!

      game.players_turn?(game.player_one).should be_true
      game.players_turn?(game.player_two).should be_false
    end

    it "should only be true for player two when game state is player_two_turn" do
      game = Game.make!
      game.player_two = Player.make!
      game.turn_played

      game.players_turn?(game.player_one).should be_false
      game.players_turn?(game.player_two).should be_true
    end

    it "should not be true if passed a nil player" do
      game = Game.make!
      game.turn_played

      game.players_turn?(game.player_one).should be_false
      game.players_turn?(nil).should be_false
    end
  end

  describe "play_turn" do
    it "should accept a turn by player one" do
      game = Game.make!

      game.play_turn(Turn.make!(letter: "M"),game.player_one.user).should == true
      game.current_word.should == "M"
      game.turns.length.should eq(1)
    end

  end
end