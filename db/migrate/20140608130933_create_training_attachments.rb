class CreateTrainingAttachments < ActiveRecord::Migration
  def change
    create_table :training_attachments do |t|
      t.integer :training_id
      t.string :attachment

      t.timestamps
    end
  end
end
