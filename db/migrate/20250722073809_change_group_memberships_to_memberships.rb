class ChangeGroupMembershipsToMemberships < ActiveRecord::Migration[8.0]
  def change
    rename_table :group_memberships, :memberships
  end
end
