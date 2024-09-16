class AddUserToWorkspaces < ActiveRecord::Migration[7.2]
  def change
    add_reference :workspaces, :user, null: false, foreign_key: true
  end
end
