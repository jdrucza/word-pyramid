class HomeController < ApplicationController
  def index
    if current_user
      @games = current_user.games
      if @games.first
        redirect_to @games.first
      else
        @game = Game.new
      end
    end
  end
end
