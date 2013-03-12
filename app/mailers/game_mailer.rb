class GameMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.game_mailer.your_turn.subject
  #
  def your_turn(game, player)
    @game = game
    @player = player
    mail to: player.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.game_mailer.challenge_made.subject
  #
  def challenge_made
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.game_mailer.game_over.subject
  #
  def game_over
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  def you_won(game, player)
    @game = game
    @player = player
    mail to: player.email
  end

  def you_lost(game, player)
    @game = game
    @player = player
    mail to: player.email
  end
end
