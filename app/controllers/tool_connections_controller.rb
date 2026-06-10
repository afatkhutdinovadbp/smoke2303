class ToolConnectionsController < ApplicationController
  def index
    membership_ids = @current_user.organization_memberships.pluck(:id)
    @tool_connections = ToolConnection
      .where(organization_membership_id: membership_ids)
      .order(updated_at: :desc)

    render json: { data: @tool_connections.map(&:as_json) }
  end
end
