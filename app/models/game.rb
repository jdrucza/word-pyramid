class Game < ActiveRecord::Base
  attr_accessible :current_word, :player_one_id, :player_two_id
  validates_presence_of :player_one_id
  belongs_to :player_one, :class_name => "Player", :dependent => :destroy
  belongs_to :player_two, :class_name => "Player", :dependent => :destroy
  has_many :players

  def self.join_new(user)
    # Check if game without second player exists else create new
    available_game = self.waiting_for_player_two.not_being_played_by(user).first
    player = Player.create!(:user_id => user.id)
    unless available_game
      available_game = Game.new
    end
    available_game.assign_player(player)
    available_game.save!
    available_game
  end

  def assign_player(player)
    if self.player_one
      self.player_two = player
    else
      self.player_one = player
    end
    self.save!
    player.game = self
    player.save!
  end

  def description
    "#{player_one.name} VS #{player_two.name}"
  end

  scope :waiting_for_player_two, where(:player_two_id => nil)
  scope :not_being_played_by, lambda{|user| joins(:players).where('players.user_id != ?', user.id)} #TODO add state not equal to complete
  scope :being_played_by, lambda{|user| joins(:players).where('players.user_id = ?', user.id)} #TODO add state NOT equal to complete
  scope :played_by, lambda{|user| joins(:players).where('players.user_id = ?', user.id)} #TODO add state equal to complete
end
