class Turn < ActiveRecord::Base
  START = "S"
  FINISH = "E"
  attr_accessible :game_id, :letter, :player_id, :position
  belongs_to :game
  belongs_to :player

  def letter=(letter)
    write_attribute(:letter, letter.upcase)
  end
end
