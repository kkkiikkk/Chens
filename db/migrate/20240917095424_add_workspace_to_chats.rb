class AddWorkspaceToChats < ActiveRecord::Migration[7.2]
  def change
    add_reference :chats, :workspace, null: false, foreign_key: true
  end
end
