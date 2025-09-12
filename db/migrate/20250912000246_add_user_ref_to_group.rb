class AddUserRefToGroup < ActiveRecord::Migration[8.0]
  def change
    add_reference :groups, :admin, null: false, foreign_key: { to_table: :users }
  end
end
