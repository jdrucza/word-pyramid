class Turn < ActiveRecord::Base
  START = "S"
  FINISH = "E"
  attr_accessible :game_id, :letter, :player_id, :position
  validates_format_of :letter, with: /[a-z,A-Z]/
  validates_length_of :letter, is: 1
  validates_inclusion_of :position, in: [START, FINISH]
  belongs_to :game
  belongs_to :player

  def letter=(letter)
    write_attribute(:letter, letter.upcase)
  end
end
