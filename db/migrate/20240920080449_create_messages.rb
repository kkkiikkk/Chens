class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.string :text, null: false
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :chat, null: false, foreign_key: true
      t.references :reply, foreign_key: { to_table: :messages }

      t.timestamps
    end
  end
end
