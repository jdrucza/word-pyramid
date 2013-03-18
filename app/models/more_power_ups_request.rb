class MorePowerUpsRequest < ActiveRecord::Base
  attr_accessible :granted, :user_id

  belongs_to :user

  scope :pending, where(granted: nil)
end
