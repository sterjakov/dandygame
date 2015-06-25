class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :day_id
      t.text :description
      t.integer :bad
      t.integer :good
      t.integer :status

      t.timestamps
    end
  end
end
