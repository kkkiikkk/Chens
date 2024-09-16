class CreateUserWorkspaces < ActiveRecord::Migration[7.2]
  def change
    create_table :user_workspaces do |t|
      t.string :profile_description
      t.string :profile_name
      t.string :profile_status, default: 'online'
      t.string :profile_title
      t.references :user, null: false, foreign_key: true
      t.references :workspace, null: false, foreign_key: true

      t.timestamps
    end
  end
end
