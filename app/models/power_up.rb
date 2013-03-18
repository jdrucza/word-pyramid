class PowerUp < ActiveRecord::Base
  attr_accessible :result_data, :used_in_game_id, :user_id

  scope :unused, where(:used_in_game_id => nil)
  scope :used_in, lambda{|game| where(:used_in_game_id => game.id)}
end
