class CreateTurns < ActiveRecord::Migration
  def change
    create_table :turns do |t|
      t.string :letter
      t.string :position
      t.integer :player_id
      t.integer :game_id

      t.timestamps
    end
  end
end
