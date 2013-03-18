class Player < ActiveRecord::Base
  attr_accessible :game_id, :user_id
  belongs_to :user
  belongs_to :game
  delegate :name, :email, :to => :user
  has_many :power_ups, :class_name => "PowerUp", :foreign_key => "user_id", :primary_key => "user_id"

  def has_available_power_up?
    power_ups.unused.exists?
  end

  def used_power_up?
    power_ups.used_in(game).exists?
  end

  def used_power_up
    power_ups.used_in(game).first
  end

  def use_power_up(word)
    power_up = power_ups.unused.first
    power_up.result_data = word
    power_up.used_in_game_id = game_id
    power_up.save!
  end
end
