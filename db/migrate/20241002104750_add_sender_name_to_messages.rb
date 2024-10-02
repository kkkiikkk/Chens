class AddSenderNameToMessages < ActiveRecord::Migration[7.2]
  def change
    add_column :messages, :sender_name, :string
  end
end
