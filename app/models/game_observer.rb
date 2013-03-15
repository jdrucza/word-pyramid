class GameObserver < ActiveRecord::Observer
  def after_turn_played(game, transition)
    unless game.over?
      player = game.player_one_turn? ? game.player_one : game.player_two
      GameMailer.your_turn(game, player).deliver if player
    end
  end

  def after_challenge_made(game, transition)
    challenged_player = game.challenged?(game.player_one) ? game.player_one : game.player_two
    GameMailer.youve_been_challenged(game, challenged_player).deliver
  end

  def after_transition(game, transition)
    if game.over?
      winner = game.player_one_won? ? game.player_one : game.player_two
      loser = game.opponent(winner)
      GameMailer.you_won(game, winner).deliver if winner
      GameMailer.you_lost(game, loser).deliver if loser
    end
  end
end
