class GameObserver < ActiveRecord::Observer
  def after_turn_played(game, transition)
    player = game.player_one_turn? ? game.player_one : game.player_two
    GameMailer.your_turn(game, player).deliver if player
  end

  def after_transition(game, transition)
    puts "      !!!!!!!!!!         in after_transition"
    if game.over?
      winner = game.player_one_won? ? game.player_one : game.player_two
      loser = game.opponent(winner)
      GameMailer.you_won(game, winner).deliver if winner
      GameMailer.you_lost(game, loser).deliver if loser
    end
  end
end
