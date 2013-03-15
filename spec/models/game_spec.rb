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

  describe "challenge_response_word_valid?" do
    it "should be true" do
      game = Game.make!
      game.current_word = "ARREN"
      game.challenge_response = "WARREN"
      game.challenge_response_word_valid?.should be_true
    end
    it "should be false" do
      game = Game.make!
      game.current_word = "ARREN"
      game.challenge_response = "ZZZARREN"
      game.challenge_response_word_valid?.should be_false
      game.current_word = "ARREN"
      game.challenge_response = "CORRECT"
      game.challenge_response_word_valid?.should be_false
    end
  end

  describe "respond_to_challenge" do
    it "should transition to player_one_won when player_two fails challenge" do
      game = Game.make!
      game.player_two = Player.make!
      game.current_word = "ARREN"
      game.challenge_made
      game.challenge_player_two?.should be_true
      GameMailer.stub_chain(:you_won, :deliver).and_return(true)
      GameMailer.stub_chain(:you_lost, :deliver).and_return(true)
      game.respond_to_challenge("XXXXARREN",game.player_two.user)
      game.player_one_won?.should be_true
    end

    it "should transition to player_two_won when player_two passes challenge" do
      game = Game.make!
      game.player_two = Player.make!
      game.current_word = "ARREN"
      game.challenge_made
      game.challenge_player_two?.should be_true
      GameMailer.stub_chain(:you_won, :deliver).and_return(true)
      GameMailer.stub_chain(:you_lost, :deliver).and_return(true)
      game.respond_to_challenge("WARREN",game.player_two.user)
      game.player_two_won?.should be_true
    end
  end

  describe "challenge_possible?" do
    it "should be true" do
      game = Game.make!
      game.play_turn(Turn.make!,game.player_one.user).should == true
      game.player_two = Player.make!
      game.challenge_possible?(game.player_two).should be_true
    end
  end

  describe "challenged? and challenger?" do
    let(:game) {
      game = Game.make!
      game.player_two = Player.make!
      game.play_turn(Turn.make!(letter:"e"),game.player_one.user).should == true
      game.play_turn(Turn.make!(letter:"n"),game.player_two.user).should == true
      game.play_turn(Turn.make!(letter:"a"),game.player_one.user).should == true
      game.play_turn(Turn.make!(letter:"s"),game.player_two.user).should == true
      game
    }

    it "should be correct before challenged player responds" do
      game.challenge(game.player_one)
      game.challenged?(game.player_two).should be_true
      game.challenged?(game.player_one).should be_false
      game.challenger?(game.player_two).should be_false
      game.challenger?(game.player_one).should be_true
    end

    it "should be correct after challenged player responds correctly" do
      game.challenge(game.player_one)
      game.respond_to_challenge("insane", game.player_two)
      game.challenged?(game.player_two).should be_true
      game.challenged?(game.player_one).should be_false
      game.challenger?(game.player_two).should be_false
      game.challenger?(game.player_one).should be_true
    end

    it "should be correct after challenged player responds incorrectly" do
      game.challenge(game.player_one)
      game.respond_to_challenge("xxsanezz", game.player_two)
      game.challenged?(game.player_two).should be_true
      game.challenged?(game.player_one).should be_false
      game.challenger?(game.player_two).should be_false
      game.challenger?(game.player_one).should be_true
    end

    it "should be false when no challenge has been made" do
      game.challenged?(game.player_two).should be_false
      game.challenged?(game.player_one).should be_false
      game.challenger?(game.player_two).should be_false
      game.challenger?(game.player_one).should be_false
    end

    it "should be false when no challenge has been made and game has ended" do
      game.play_turn(Turn.make!(letter:"n"),game.player_one.user).should == true
      game.play_turn(Turn.make!(letter:"i"),game.player_two.user).should == true
      game.over?.should be_true
      game.challenged?(game.player_two).should be_false
      game.challenged?(game.player_one).should be_false
      game.challenger?(game.player_two).should be_false
      game.challenger?(game.player_one).should be_false
    end
  end
end