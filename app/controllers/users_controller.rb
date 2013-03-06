class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.all
  end

  def show
    puts params
    @user = User.find(params[:id])
    puts @user
  end

end
