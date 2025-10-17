class AddBrailleRefToComments < ActiveRecord::Migration[8.0]
  def change
    add_reference :comments, :braille, foreign_key: { on_delete: :nullify }, null: true, index: { unique: true }
  end
end
