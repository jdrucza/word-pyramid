class GamesController < ApplicationController
  # GET /games
  # GET /games.json
  def index
    @games = Game.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])
    @turn = Turn.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  def spectate
    # TODO - this could be awesome...
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.json
  def create
    # TODO only allowing one game is for prototype only which is also the reason the logic is in the controller rather than
    # the model
    @game = Game.being_played_by(current_user).first

    @game = Game.join_new(current_user) unless @game

    respond_to do |format|
      if @game
        format.html { redirect_to @game, notice: 'Game joined.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { redirect_to home_url, :notice => "Unable to start a new game at this time, please try again later." }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def challenge
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.challenge(current_user)
        format.html { redirect_to @game, notice: 'Challenge accepted.' }
        format.json { render json: @game, status: :accepted, location: @game }
      else
        format.html { redirect_to home_url, :notice => "Challenge failed, please contact support." }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def respond_to_challenge
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.respond_to_challenge(params[:challenge_response],current_user)
        format.html { redirect_to @game, notice: 'Challenge accepted.' }
        format.json { render json: @game, status: :accepted, location: @game }
      else
        format.html { redirect_to home_url, :notice => "Challenge failed, please contact support." }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end
end
