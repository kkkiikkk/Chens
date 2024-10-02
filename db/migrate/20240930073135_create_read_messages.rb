class CreateReadMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :message_reads do |t|
      t.references :user, null: false, foreign_key: true
      t.references :message, null: false, foreign_key: true

      t.timestamps
    end

    add_index :message_reads, [:message_id, :user_id], unique: true
  end
end
