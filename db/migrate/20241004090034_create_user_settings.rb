class CreateUserSettings < ActiveRecord::Migration[7.2]
  def change
    create_table :user_settings do |t|
      t.boolean :notifications, default: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
