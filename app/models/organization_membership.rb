class OrganizationMembership < ApplicationRecord
  include UuidPrimaryKey

  belongs_to :user
  has_many :tool_connections, dependent: :destroy
end
