class GameObserver < ActiveRecord::Observer
  def after_turn_played(game, transition)
    player = game.player_one_turn? ? game.player_one : game.player_two
    GameMailer.your_turn(game, player).deliver if player
  end
  def after_transition_to_player_one_won(game, transition)
    puts "      !!!!!!!!!!         in after_transition_to_player_one_won"
    winner = game.player_one
    loser = game.opponent(winner)
    GameMailer.you_win(game, winner).deliver if winner
    GameMailer.you_lose(game, loser).deliver if loser
  end
  def after_transition_to_player_two_won(game, transition)
    puts "      !!!!!!!!!!         in after_transition_to_player_two_won"
    winner = game.player_two
    loser = game.opponent(winner)
    GameMailer.you_win(game, winner).deliver if winner
    GameMailer.you_lose(game, loser).deliver if loser
  end
end
