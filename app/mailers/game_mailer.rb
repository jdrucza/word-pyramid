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
  def youve_been_challenged(game, player)
    @game = game
    @player = player
    mail to: player.email
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

  def power_ups_requested(user)
    @user = user
    mail to: ['admin@leeu.com.au', 'james@nativetongue.com']
    #mail to: ['james@nativetongue.com','james@drucza.net']
  end
end
