class CreateOrganizationMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :organization_memberships, id: false do |t|
      t.string :id, null: false, primary_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
