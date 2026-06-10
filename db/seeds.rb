User.create([
  { username: "John", email: "john@email.com", password: "secret" },
  { username: "Steve", email: "steve@email.com", password: "secret" },
  { username: "Jenna", email: "jenna@email.com", password: "secret" }
])

membership = OrganizationMembership.create!(id: "accbfcf6-c928-43f7-8456-ce6e6ebaa0ab", user: User.first)

ToolConnection.create!([
  {
    id: "48120e78-4628-4d04-83fb-8998cdc404b9",
    tool_name: "claude_code",
    connection_state: "active",
    organization_membership: membership,
    scope: "persona",
    last_used_at: Time.utc(2026, 6, 10, 12, 53, 24)
  },
  {
    id: "436ddb80-e340-4c9b-9c69-fe9b14a0609f",
    tool_name: "cursor",
    connection_state: "active",
    organization_membership: membership,
    scope: "persona",
    last_used_at: Time.utc(2026, 6, 10, 0, 0, 0)
  }
])
