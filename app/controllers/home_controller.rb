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
end
