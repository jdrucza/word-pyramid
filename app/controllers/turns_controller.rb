class TurnsController < ApplicationController
  before_filter :find_game
  def find_game
    @game = Game.find(params[:game_id])
  end
  # GET /turns
  # GET /turns.json
  def index
    @turns = Turn.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @turns }
    end
  end

  # GET /turns/1
  # GET /turns/1.json
  def show
    @turn = Turn.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @turn }
    end
  end

  # GET /turns/new
  # GET /turns/new.json
  def new
    @turn = Turn.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @turn }
    end
  end

  # GET /turns/1/edit
  def edit
    @turn = Turn.find(params[:id])
  end

  # POST /turns
  # POST /turns.json
  def create
    turn = Turn.new(letter:params[:letter],position:params[:position])
    @game.play_turn(turn, current_user)

    respond_to do |format|
      if turn.persisted?
        format.html { redirect_to @game, notice: 'Turn was successfully played.' }
        puts @game.as_json
        format.json { render json: @game, status: :accepted, location: @game }
      else
        format.html { redirect_to @game, notice: 'Turn failed.' }
        format.json { render json: @turn.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /turns/1
  # PUT /turns/1.json
  def update
    @turn = Turn.find(params[:id])

    respond_to do |format|
      if @turn.update_attributes(params[:turn])
        format.html { redirect_to @turn, notice: 'Turn was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @turn.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /turns/1
  # DELETE /turns/1.json
  def destroy
    @turn = Turn.find(params[:id])
    @turn.destroy

    respond_to do |format|
      format.html { redirect_to turns_url }
      format.json { head :no_content }
    end
  end
end
