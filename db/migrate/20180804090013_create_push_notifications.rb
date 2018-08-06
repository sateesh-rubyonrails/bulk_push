class CreatePushNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :push_notifications do |t|
      t.integer :start_id
      t.integer :end_id
      t.string :status

      t.timestamps
    end
  end
end
