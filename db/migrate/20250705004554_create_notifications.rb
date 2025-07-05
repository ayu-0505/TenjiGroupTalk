class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.boolean :read, default: false, null: false
      t.references :user, null: false, foreign_key: true
      t.references :notifiable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
