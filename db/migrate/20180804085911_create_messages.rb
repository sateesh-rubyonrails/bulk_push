class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.jsonb :message
      t.string :status

      t.timestamps
    end
  end
end
