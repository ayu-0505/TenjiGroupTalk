class CreateTalks < ActiveRecord::Migration[8.0]
  def change
    create_table :talks do |t|
      t.string :title, null: false
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
