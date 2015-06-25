class CreateUserDays < ActiveRecord::Migration
  def change
    create_table :user_days, id: false do |t|
      t.references :user, index: true
      t.references :day, index: true
    end
  end
end
