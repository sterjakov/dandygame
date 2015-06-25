class CreateMytrainings < ActiveRecord::Migration
  def change
    create_table :mytrainings do |t|
      t.integer :training_id
      t.integer :user_id
      t.integer :day_number
      t.integer :status, default: 0
      t.integer :viewed, default: 0
      t.datetime :activated_at

      t.timestamps null: false
    end
  end
end
