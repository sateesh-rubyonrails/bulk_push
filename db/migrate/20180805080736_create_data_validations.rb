class CreateDataValidations < ActiveRecord::Migration[5.2]
  def change
    create_table :data_validations do |t|
      t.integer :start_id
      t.integer :end_id
      t.text :xml_messages_ary
      t.text :json_messages_ary
      t.string :process_id


      t.timestamps
    end
  end
end
