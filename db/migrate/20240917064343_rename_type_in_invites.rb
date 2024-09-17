class RenameTypeInInvites < ActiveRecord::Migration[7.2]
  def change
    rename_column :invites, :type, :invite_type
  end
end
