class CreateTrainings < ActiveRecord::Migration
  def change
    create_table :trainings do |t|
      t.string :name
      t.string :alt_name
      t.text :description
      t.text :min_description
      t.integer :people_count, default: 0
      t.integer :feedback_count, default: 0
      t.integer :day_count, default: 0
      t.integer :free_day, default: 0
      t.integer :price, default: 0
      t.string :icon
      t.integer :weight
      t.text :html
      t.text :css
      t.integer :category_id
      t.integer :status, default: 0
      t.string :meta_description
      t.string :meta_keywords

      t.timestamps
    end
  end
end