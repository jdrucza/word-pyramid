class HomeController < ApplicationController
  def index
    if current_user
      @games = Game.being_played_by(current_user)
      if @games.first
        redirect_to @games.first
      else
        @game = Game.new
      end
    end
  end

  def help
    #nothing to do
  end

  def terms_and_conditions
    #nothing to do
  end
end
