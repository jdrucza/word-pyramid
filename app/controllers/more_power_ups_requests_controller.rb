class MorePowerUpsRequestsController < ApplicationController
  before_filter :ensure_admin, :except => :create

  def ensure_admin
    if current_user.admin?
      true
    else
      redirect_to home_path
    end
  end
  # GET /more_power_ups_requests
  # GET /more_power_ups_requests.json
  def index
    @more_power_ups_requests = MorePowerUpsRequest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @more_power_ups_requests }
    end
  end

  # GET /more_power_ups_requests/1
  # GET /more_power_ups_requests/1.json
  def show
    @more_power_ups_request = MorePowerUpsRequest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @more_power_ups_request }
    end
  end

  # GET /more_power_ups_requests/new
  # GET /more_power_ups_requests/new.json
  def new
    @more_power_ups_request = MorePowerUpsRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @more_power_ups_request }
    end
  end

  # GET /more_power_ups_requests/1/edit
  def edit
    @more_power_ups_request = MorePowerUpsRequest.find(params[:id])
  end

  # POST /more_power_ups_requests
  # POST /more_power_ups_requests.json
  def create
    @more_power_ups_request = MorePowerUpsRequest.new(user_id: current_user.id)

    respond_to do |format|
      if @more_power_ups_request.save
        GameMailer.power_ups_requested(current_user).deliver
        format.html
        format.json { render json: @more_power_ups_request, status: :created, location: @more_power_ups_request }
      else
        format.html { render action: "new" }
        format.json { render json: @more_power_ups_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /more_power_ups_requests/1
  # PUT /more_power_ups_requests/1.json
  def update
    @more_power_ups_request = MorePowerUpsRequest.find(params[:id])

    respond_to do |format|
      if @more_power_ups_request.update_attributes(params[:more_power_ups_request])
        format.html { redirect_to @more_power_ups_request, notice: 'More power ups request was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @more_power_ups_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /more_power_ups_requests/1
  # DELETE /more_power_ups_requests/1.json
  def destroy
    @more_power_ups_request = MorePowerUpsRequest.find(params[:id])
    @more_power_ups_request.destroy

    respond_to do |format|
      format.html { redirect_to more_power_ups_requests_url }
      format.json { head :no_content }
    end
  end
end
