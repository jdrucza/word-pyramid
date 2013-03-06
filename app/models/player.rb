class Player < ActiveRecord::Base
  attr_accessible :game_id, :user_id
  belongs_to :user
  belongs_to :game
  delegate :name, :email, :to => :user
end
