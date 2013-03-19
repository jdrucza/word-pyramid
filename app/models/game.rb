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
      transition :challenge_player_one => :player_two_won
      transition :challenge_player_two => :player_one_won
    end
  end

  def word_valid?(word)
    word.length > 4 and Word.exists?(word)
  end

  def current_word_valid?
    word_valid?(current_word)
  end

  def challenge_response_word_valid?
    challenge_response.match(current_word) and word_valid?(challenge_response)
  end

  def player_for_user(user)
    players.where("user_id = #{user.id}").first or raise("User is not playing this game!")
  end

  def ensure_player(player_or_user)
    player = player_or_user.is_a?(Player) ? player_or_user : player_for_user(player_or_user)
    player.game == self ? player : raise("Player is not playing this game!")
  end

  def opponent(player)
    player = ensure_player(player)
    player_one == player ? player_two : player_one
  end

  def player_one?(user)
    player = ensure_player(user)
    @game.player_one == player
  end

  def player_two?(user)
    player = ensure_player(user)
    @game.player_two == player
  end

  def over?
    player_one_won? or player_two_won?
  end

  def play_turn(turn, player)
    player = ensure_player(player)
    turn.player = player
    if players_turn?(player)
      transaction do
        turns << turn
        self.current_word = turn.letter + self.current_word if turn.position == Turn::START
        self.current_word = self.current_word + turn.letter if turn.position == Turn::FINISH
        turn_played
        save!
      end
    else
      turn.errors[:base] << "Not your turn"
      false
    end
  end

  def challenge(player)
    if challenge_possible?(player)
      challenge_made
      save!
    else
      errors[:base] << "Not your turn."
      false
    end
  end

  def respond_to_challenge(response, player)
    if challenged?(player)
      self.challenge_response = response
      challenge_responded
      save!
    else
      errors[:base] << "You haven't been challenged."
      false
    end
  end

  def use_power_up(player)
    player = ensure_player(player)
    if power_up_possible?(player)
      suggested_word = word_suggestion
      puts "    !!!!!!      SUGGESTED word is #{suggested_word}"
      player.use_power_up(suggested_word)
    else
      errors[:base] << "Not your turn or no Power Ups available."
      false
    end
  end

  def power_up_possible?(player)
    player = ensure_player(player)
    players_turn?(player) and player.has_available_power_up? and not player.used_power_up?
  end

  def used_power_up?(user)
    player = ensure_player(user)
    player.used_power_up?
  end

  def used_power_up(user)
    player = ensure_player(user)
    player.used_power_up
  end

  def players_turn?(player)
    player and ((player_one_turn? and player == player_one) or (player_two_turn? and player == player_two))
  end

  def users_turn?(user)
    players_turn?(player_for_user(user))
  end

  def challenge_possible?(player)
    player = ensure_player(player)
    current_word.length > 0 and players_turn?(player)
  end

  def challenged?(player)
    player = ensure_player(player)
    ((challenge_player_one? and (player == player_one)) or
        (challenge_player_two? and (player == player_two))) or
        (over? and challenge_response and (turns.last.player == player))
  end

  def challenger?(player)
    player = ensure_player(player)
    ((challenge_player_one? and (player == player_two)) or
        (challenge_player_two? and (player == player_one))) or
        (over? and challenge_response and turns.last.player == opponent(player))
  end

  def word_suggestion
    candidates = Word.containing_and_longer_than(current_word, current_word.length+1)
    odd_or_even = current_word.length % 2
    game_word = current_word.downcase

    longest = 0
    by_length = {}
    candidates.each_pair{|w,l|
      longest = l if l > longest
      by_length[l] ||= []
      by_length[l] << w
    }

    found_word = nil

    by_length.sort.reverse.each{|l,word_list|
      unless l % 2 == odd_or_even and !found_word
        word_list.each{|word|
          unless found_word
            puts "  WORD:  #{word}    ||||    GAME_WORD:   #{game_word}"
            char_after = word[word.index(game_word)+game_word.length]
            char_before = word[word.index(game_word)-1]
            s1 = (char_after ? game_word+char_after : nil)
            s2 = (char_before ? char_before+game_word : nil)
            if (s1 or s2) and Word.containing_s1_or_s2_excluding(s1, s2, word)
              found_word = word
            end
          end
        }
      end
    }
    found_word
  end

  def current_word
    self.read_attribute(:current_word) or ""
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
  scope :not_being_played_by, lambda{|user| joins(:players).where("players.user_id != ? and state not in ('player_two_won','player_one_won')", user.id).readonly(false)}
  scope :being_played_by, lambda{|user| joins(:players).where("players.user_id = ? and state not in ('player_two_won','player_one_won')", user.id).readonly(false)}
  scope :played_by, lambda{|user| joins(:players).where("players.user_id = ? and state in ('player_two_won','player_one_won')", user.id).readonly(false)}
  scope :won_by, lambda{|user|
    find_by_sql(["select g.* from games g join players p1 on g.player_one_id = p1.id join players p2 on g.player_two_id = p2.id where g.state = 'player_one_won' and p1.user_id = ? or g.state = 'player_two_won' and p2.user_id = ?",
                user.id, user.id])}
  scope :won_by_as_player_one, lambda{|user| joins(:player_one).where(:state => 'player_one_won', :players => {:user_id => user})}
  scope :won_by_as_player_two, lambda{|user| joins(:player_two).where(:state => 'player_two_won', :players => {:user_id => user})}

  def self.won_by_count(user)
    won_by_as_player_one(user).count + won_by_as_player_two(user).count
  end
end
