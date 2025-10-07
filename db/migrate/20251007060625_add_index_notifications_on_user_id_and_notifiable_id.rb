class AddIndexNotificationsOnUserIdAndNotifiableId < ActiveRecord::Migration[8.0]
  def change
    add_index :notifications, [:user_id, :notifiable_id], unique: true
  end
end
