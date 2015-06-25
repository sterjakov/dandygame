class CreateActivations < ActiveRecord::Migration
  def change
    create_table :activations do |t|
      t.integer :training_id
      t.integer :day_number
      t.integer :user_id
      t.integer :money

      t.timestamps null: false
    end
  end
end