class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    unless current_user.admin?
      redirect_to home_path
    else
      @users = User.all
    end
  end

  def show
    unless current_user.admin?
      redirect_to home_path
    else
      @user = User.find(params[:id])
    end
  end

  def add_power_ups
    unless current_user.admin?
      redirect_to home_path
    else
      @user = User.find(params[:id])
      3.times{ PowerUp.create!(user_id: @user.id)}
      render :show
    end
  end
end
