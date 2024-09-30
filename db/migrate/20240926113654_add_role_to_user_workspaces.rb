class AddRoleToUserWorkspaces < ActiveRecord::Migration[7.2]
  def change
    add_column :user_workspaces, :role, :string, null: false, default: 'member'
  end
end
