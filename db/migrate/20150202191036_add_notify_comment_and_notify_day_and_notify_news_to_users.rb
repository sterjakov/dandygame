class AddNotifyCommentAndNotifyDayAndNotifyNewsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notify_comment, :integer
    add_column :users, :notify_day, :integer
    add_column :users, :notify_news, :integer
  end
end
