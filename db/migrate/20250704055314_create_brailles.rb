class CreateBrailles < ActiveRecord::Migration[8.0]
  def change
    create_table :brailles do |t|
      t.text :original_text, null: false
      t.text :raised_braille, null: false
      t.text :indented_braille, null: false
      t.references :user, null: false, foreign_key: true
      t.references :brailleable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
