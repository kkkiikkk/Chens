class RemovePictureFromWorkspaces < ActiveRecord::Migration[7.2]
  def change
    remove_column :workspaces, :picture, :string
  end
end
