require 'spec_helper'


describe TurnsController do

  # This should return the minimal set of attributes required to create a valid
  # Turn. As you add validations to Turn, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "letter" => "M" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TurnsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  #describe "GET index" do
  #  it "assigns all turns as @turns" do
  #    turn = Turn.create! valid_attributes
  #    get :index, {}, valid_session
  #    assigns(:turns).should eq([turn])
  #  end
  #end
  #
  #describe "GET show" do
  #  it "assigns the requested turn as @turn" do
  #    turn = Turn.create! valid_attributes
  #    get :show, {:id => turn.to_param}, valid_session
  #    assigns(:turn).should eq(turn)
  #  end
  #end
  #
  #describe "GET new" do
  #  it "assigns a new turn as @turn" do
  #    get :new, {}, valid_session
  #    assigns(:turn).should be_a_new(Turn)
  #  end
  #end
  #
  #describe "GET edit" do
  #  it "assigns the requested turn as @turn" do
  #    turn = Turn.create! valid_attributes
  #    get :edit, {:id => turn.to_param}, valid_session
  #    assigns(:turn).should eq(turn)
  #  end
  #end


end
