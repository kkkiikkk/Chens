class AddBlockedToUserWorkspace < ActiveRecord::Migration[7.2]
  def change
    add_column :user_workspaces, :blocked, :bool, default: false
  end
end
