class AddChallengeResponseToGame < ActiveRecord::Migration
  def change
    add_column :games, :challenge_response, :string
  end
end
