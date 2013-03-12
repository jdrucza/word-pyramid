class GameObserver < ActiveRecord::Observer
  def after_turn_played(game, transition)
    player = game.player_one_turn? ? game.player_one : game.player_two
    GameMailer.your_turn(game, player).deliver if player
  end
end
