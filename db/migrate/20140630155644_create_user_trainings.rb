class CreateUserTrainings < ActiveRecord::Migration
  def change
    create_table :user_trainings, id: false do |t|
      t.references :user, index: true
      t.references :trainings, index: true
    end
  end
end
