class AddTypeToInvites < ActiveRecord::Migration[7.2]
  def change
    add_column :invites, :type, :string, default: 'public'
  end
end
