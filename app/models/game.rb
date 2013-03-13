class Game < ActiveRecord::Base
  attr_accessible :current_word, :challenge_response, :player_one_id, :player_two_id
  validates_presence_of :player_one_id
  belongs_to :player_one, :class_name => "Player", :dependent => :destroy
  belongs_to :player_two, :class_name => "Player", :dependent => :destroy
  has_many :players
  has_many :turns, :dependent => :destroy

  def player_one=(player)
    players << player
    super(player)
  end

  def player_two=(player)
    players << player
    super(player)
  end

  state_machine :state, :initial => :player_one_turn do
    state :player_one_turn
    state :player_two_turn
    state :challenge_player_one
    state :challenge_player_two
    state :player_one_won
    state :player_two_won

    event :turn_played do
      transition :player_one_turn => :player_two_won, :if => lambda{|game| game.current_word_valid?}
      transition :player_two_turn => :player_one_won, :if => lambda{|game| game.current_word_valid?}
      transition :player_one_turn => :player_two_turn
      transition :player_two_turn => :player_one_turn
    end

    event :challenge_made do
      transition :player_one_turn => :challenge_player_two
      transition :player_two_turn => :challenge_player_one
    end

    event :challenge_responded do
      transition :challenge_player_one => :player_one_won, :if => lambda{|game| game.challenge_response_word_valid?}
      transition :challenge_player_two => :player_two_won, :if => lambda{|game| game.challenge_response_word_valid?}
      transition :player_one_turn => :player_two_won
      transition :player_two_turn => :player_one_won
    end
  end

  def word_valid?(word)
    word.length > 4 and Word.exists?(current_word)
  end

  def current_word_valid?
    word_valid?(current_word)
  end

  def challenge_response_word_valid
    word_valid(challenge_response)
  end

  def player_for_user(user)
    players.where("user_id = #{user.id}").first
  end

  def opponent(player_or_user)
    player = player_or_user.is_a?(Player) ? player_or_user : player_for_user(player_or_user)
    player_one == player ? player_two : player_one
  end

  def over?
    player_one_won? or player_two_won?
  end

  def play_turn(turn, user)
    player = player_for_user(user)
    turn.player = player
    if players_turn?(player)
      turns << turn
      turn.save!
      self.current_word = turn.letter + self.current_word if turn.position == Turn::START
      self.current_word = self.current_word + turn.letter if turn.position == Turn::FINISH
      turn_played
      save!
    else
      turn.errors[:base] << "Not your turn"
      false
    end
  end

  def players_turn?(player)
    player and ((player_one_turn? and player == player_one) or (player_two_turn? and player == player_two))
  end

  def users_turn?(user)
    players_turn?(player_for_user(user))
  end

  def current_word
    self.read_attribute(:current_word) or ""
  end

  def self.join_new(user)
    # Check if game without second player exists else create new
    available_game = self.waiting_for_player_two.not_being_played_by(user).readonly(false).first
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
  scope :not_being_played_by, lambda{|user| joins(:players).where("players.user_id != ? and state not in ('player_two_won','player_one_won')", user.id)}
  scope :being_played_by, lambda{|user| joins(:players).where("players.user_id = ? and state not in ('player_two_won','player_one_won')", user.id)}
  scope :played_by, lambda{|user| joins(:players).where('players.user_id = ?', user.id)} #TODO add state equal to complete, maybe....
end
