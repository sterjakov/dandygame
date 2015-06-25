class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :user_id
      t.integer :training_id
      t.text :description
      t.integer :bad
      t.integer :good
      t.integer :status

      t.timestamps
    end
  end
end
