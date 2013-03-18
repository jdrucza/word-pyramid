class CreateMorePowerUpsRequests < ActiveRecord::Migration
  def change
    create_table :more_power_ups_requests do |t|
      t.integer :user_id
      t.boolean :granted

      t.timestamps
    end
  end
end
