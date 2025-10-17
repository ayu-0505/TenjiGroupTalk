class RemovePolymorphicColumnsFromNotifications < ActiveRecord::Migration[8.0]
  def change
    remove_index :notifications, name: 'index_notifications_on_user_id_and_notifiable_id'
    remove_column :notifications, :notifiable_type, :string
    remove_column :notifications, :notifiable_id, :integer
  end
end
