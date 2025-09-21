class AddIndexSubscriptionsOnUserIdAndTalkId < ActiveRecord::Migration[8.0]
  def change
    add_index :subscriptions, [:user_id, :talk_id], unique: true
  end
end
