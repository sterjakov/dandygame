class CreateDayAttachments < ActiveRecord::Migration
  def change
    create_table :day_attachments do |t|
      t.string :day_id
      t.string :attachment

      t.timestamps
    end
  end
end
