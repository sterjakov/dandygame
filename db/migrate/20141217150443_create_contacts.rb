class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.text :description
      t.string :email
      t.string :theme

      t.timestamps null: false
    end
  end
end
