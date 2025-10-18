class RemovePolymorphicColumnsFromBrailles < ActiveRecord::Migration[8.0]
  def change
    remove_column :brailles, :brailleable_type, :string
    remove_column :brailles, :brailleable_id, :integer
  end
end
