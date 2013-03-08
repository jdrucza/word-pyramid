class Game < ActiveRecord::Base
  attr_accessible :current_word, :player_one_id, :player_two_id
  validates_presence_of :player_one_id
  belongs_to :player_one, :class_name => "Player", :dependent => :destroy
  belongs_to :player_two, :class_name => "Player", :dependent => :destroy
  has_many :players

  state_machine :state, :initial => :player_one_turn do
    state :player_one_turn
    state :player_two_turn
    state :challenge_player_one
    state :challenge_player_two
    state :game_over

    event :turn_played do
      transition :player_one_turn => :player_two_turn
      transition :player_two_turn => :player_one_turn
    end

    event :word_completed do
      transition :player_one_turn => :game_over
      transition :player_two_turn => :game_over
    end

    event :challenge_made do
      transition :player_one_turn => :challenge_player_two
      transition :player_two_turn => :challenge_player_one
    end

    event :challenge_won do
      transition :challenge_player_one => :game_over
      transition :challenge_player_two => :game_over
    end

    event :challenge_lost do
      transition :challenge_player_one => :game_over
      transition :challenge_player_two => :game_over
    end
  end

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

  def player_one_name
    player_one ? player_one.name : "No-one"
  end

  def player_two_name
    player_two ? player_two.name : "Awaiting Opponent"
  end

  def description
    "#{player_one_name} vs #{player_two_name}"
  end

  scope :waiting_for_player_two, where(:player_two_id => nil)
  scope :not_being_played_by, lambda{|user| joins(:players).where('players.user_id != ?', user.id)} #TODO add state not equal to complete
  scope :being_played_by, lambda{|user| joins(:players).where('players.user_id = ?', user.id)} #TODO add state NOT equal to complete
  scope :played_by, lambda{|user| joins(:players).where('players.user_id = ?', user.id)} #TODO add state equal to complete
end
