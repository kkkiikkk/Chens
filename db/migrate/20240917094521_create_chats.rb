class CreateChats < ActiveRecord::Migration[7.2]
  def change
    create_table :chats do |t|
      t.string :name
      t.string :chat_type
      t.string :chat_status

      t.timestamps
    end
  end
end
