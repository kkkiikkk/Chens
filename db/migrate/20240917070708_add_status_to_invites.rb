class AddStatusToInvites < ActiveRecord::Migration[7.2]
  def change
    add_column :invites, :status, :string, default: 'unconfirmed'
  end
end
