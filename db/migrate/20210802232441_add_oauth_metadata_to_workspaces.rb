class AddOauthMetadataToWorkspaces < ActiveRecord::Migration[6.1]
  def change
    add_column :workspaces, :oauth_version, :string
    add_column :workspaces, :oauth_scopes, :string
  end
end
