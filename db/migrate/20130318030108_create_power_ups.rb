class CreatePowerUps < ActiveRecord::Migration
  def change
    create_table :power_ups do |t|
      t.integer :user_id
      t.integer :used_in_game_id
      t.string :result_data

      t.timestamps
    end
  end
end
