class CreateWorkspaces < ActiveRecord::Migration[7.2]
  def change
    create_table :workspaces do |t|
      t.string :name
      t.string :description
      t.string :picture

      t.timestamps
    end
  end
end
