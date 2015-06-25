class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.string  :training_id
      t.integer :number
      t.string  :name
      t.text    :description
      t.text    :html
      t.text    :css

      t.timestamps
    end
  end
end