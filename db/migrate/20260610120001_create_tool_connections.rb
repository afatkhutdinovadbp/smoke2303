class CreateToolConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :tool_connections, id: false do |t|
      t.string :id, null: false, primary_key: true
      t.string :tool_name, null: false
      t.string :connection_state, null: false, default: 'active'
      t.string :external_user_id
      t.string :external_username
      t.string :external_email
      t.datetime :token_expires_at
      t.string :organization_membership_id, null: false
      t.string :scope, null: false, default: 'persona'
      t.datetime :last_used_at

      t.timestamps
    end

    add_index :tool_connections, :organization_membership_id
    add_index :tool_connections, [:organization_membership_id, :tool_name], unique: true, name: 'index_tool_connections_on_membership_and_tool'
    add_foreign_key :tool_connections, :organization_memberships, column: :organization_membership_id, primary_key: :id
  end
end
