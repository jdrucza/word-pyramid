class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  has_many :power_ups

  def admin?
    %w(james@nativetongue.com matthew@nativetonge.com andrewhfitz@gmail.com cjjackett@gmail.com tdramm@gmail.com steve.ramm@gmail.com jjacko.1623@gmail.com).include?(email)
  end
end
