class PowerUp < ActiveRecord::Base
  attr_accessible :result_data, :used_in_game_id, :user_id

  scope :unused, where(:used_in_game_id => nil)
  scope :used_in, lambda{|game| where(:used_in_game_id => game.id)}

  def result_data
    read_attribute :result_data or ""
  end

  def self.grant_three(user, pending_request = nil)
    3.times{ PowerUp.create!(user_id: user.id)}
    pending_request = pending_request or MorePowerUpsRequest.pending.where(user_id: user.id)
    if pending_request
      pending_request.granted = true
      pending_request.save!
    end
  end
end
