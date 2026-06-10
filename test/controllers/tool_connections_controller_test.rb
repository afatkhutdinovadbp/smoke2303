require "test_helper"

class ToolConnectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @token = JsonWebToken.encode(user_id: @user.id)
    @headers = { Authorization: @token }
  end

  test "should get index" do
    get '/api/tool_connections', headers: @headers, as: :json

    assert_response :success

    body = JSON.parse(response.body)
    assert body.key?("data")
    assert_equal 2, body["data"].length

    tool_names = body["data"].map { |connection| connection["toolName"] }
    assert_includes tool_names, "claude_code"
    assert_includes tool_names, "cursor"

    claude_connection = body["data"].find { |connection| connection["toolName"] == "claude_code" }
    assert_equal "48120e78-4628-4d04-83fb-8998cdc404b9", claude_connection["id"]
    assert_equal "active", claude_connection["connectionState"]
    assert_equal "accbfcf6-c928-43f7-8456-ce6e6ebaa0ab", claude_connection["organizationMembershipId"]
    assert_equal false, claude_connection["tokenExpired"]
    assert_equal "persona", claude_connection["scope"]
  end

  test "should require authentication" do
    get '/api/tool_connections', as: :json

    assert_response :unauthorized
  end
end
