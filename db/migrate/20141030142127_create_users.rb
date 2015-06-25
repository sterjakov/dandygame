class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :new_email
      t.string :password_hash
      t.string :password_salt
      t.string :nickname
      t.datetime :birthday
      t.integer :age
      t.integer :gender
      t.integer :country
      t.integer :city
      t.integer :subscribe
      t.integer :money, default: 0
      t.integer :role
      t.text :description
      t.string :avatar
      t.string :ip
      t.integer :referer
      t.integer :confirm
      t.string :auth_token
      t.string :email_token
      t.string :password_token

      t.timestamps
    end
  end
end