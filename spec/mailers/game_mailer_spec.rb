require "spec_helper"

describe GameMailer do
  describe "your_turn" do
    let(:mail) {
      @game = Game.make!
      @player = @game.player_one
      GameMailer.your_turn(@game, @player) }

    it "renders the headers" do
      mail.subject.should eq("Your turn")
      mail.to.should eq([@player.user.email])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hey")
    end
  end

  describe "challenge_made" do
    let(:mail) { GameMailer.challenge_made }

    it "renders the headers" do
      mail.subject.should eq("Challenge made")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "game_over" do
    let(:mail) { GameMailer.game_over }

    it "renders the headers" do
      mail.subject.should eq("Game over")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
