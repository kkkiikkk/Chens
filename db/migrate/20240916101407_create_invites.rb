class CreateInvites < ActiveRecord::Migration[7.2]
  def change
    create_table :invites do |t|
      t.string :email, null: false
      t.string :token, null: false
      t.references :user, foreign_key: true
      t.references :workspace, foreign_key: true

      t.timestamps
    end

    add_index :invites, :token, unique: true
  end
end
