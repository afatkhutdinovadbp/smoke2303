class ToolConnection < ApplicationRecord
  include UuidPrimaryKey

  belongs_to :organization_membership

  validates :tool_name, :connection_state, :scope, presence: true
  validates :tool_name, uniqueness: { scope: :organization_membership_id }

  def token_expired?
    token_expires_at.present? && token_expires_at < Time.current
  end

  def as_json(_options = {})
    {
      id: id,
      toolName: tool_name,
      connectionState: connection_state,
      externalUserId: external_user_id,
      externalUsername: external_username,
      externalEmail: external_email,
      createdAt: created_at&.utc&.iso8601,
      updatedAt: updated_at&.utc&.iso8601,
      tokenExpiresAt: token_expires_at&.utc&.iso8601,
      organizationMembershipId: organization_membership_id,
      tokenExpired: token_expired?,
      scope: scope,
      lastUsedAt: last_used_at&.utc&.iso8601
    }
  end
end
