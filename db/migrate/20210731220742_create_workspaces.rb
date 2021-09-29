class CreateWorkspaces < ActiveRecord::Migration[6.1]
  def change
    create_table :workspaces do |t|
      t.string :slack_team_id
      t.string :name
      t.string :token

      t.timestamps
    end
    add_index :workspaces, :slack_team_id
  end
end
