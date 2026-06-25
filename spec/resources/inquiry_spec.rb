# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe AnswerLayer::InquiryResource do
  it "routes inquiry requests" do
    client = resource_client_with({ "session_id" => "session_1" })

    client.inquiry.create_session(connection_id: "conn_1")
    client.inquiry.list_sessions
    client.inquiry.session(session_id: "session_1")
    client.inquiry.turn_stream(session_id: "session_1", user_input: "show revenue")
    client.inquiry.turn_sync(session_id: "session_1", user_input: "show revenue")

    expect_routes(
      { method: :post, path: "/inquiry/sessions" },
      { method: :get, path: "/inquiry/sessions" },
      { method: :get, path: "/inquiry/sessions/session_1" },
      { method: :post, path: "/inquiry/sessions/session_1" },
      { method: :post, path: "/inquiry/sessions/session_1/sync" }
    )
  end

  it "returns an ApiResponse for the captured inquiry create session response" do
    client = resource_client_with(fixture("inquiry/create-session"))

    response = client.inquiry.create_session(connection_id: "conn_1")

    expect(response).to be_a(AnswerLayer::ApiResponse)
    expect(response["session_id"]).not_to be_empty
  end

  it "returns an Array for the captured inquiry list sessions response" do
    client = resource_client_with(fixture("inquiry/list-sessions"))

    response = client.inquiry.list_sessions

    expect(response).to be_an(Array)
    expect(response).not_to be_empty
    expect(response).to all(be_a(Hash))

    session = response.first
    expect(session).to include("id", "connection_id", "status", "model", "turn_count")
    expect(session["id"]).to be_a(String)
    expect(session["id"]).not_to be_empty
  end

  it "returns a Hash for the captured inquiry session detail response" do
    client = resource_client_with(fixture("inquiry/session-detail"))

    response = client.inquiry.session(session_id: "session_1")

    expect(response).to include("id", "connection_id", "status", "turns")
    expect(response["turns"]).to be_an(Array)
    expect(response["turns"]).to all(be_a(Hash))
  end

  it "returns stream events for a captured inquiry turn stream" do
    skip "client.inquiry.turn_stream -> POST /inquiry/sessions/:session_id is blocked until a live API response fixture is created; fixture capture was skipped to avoid additional long-running or costly agent work."
  end

  it "returns an ApiResponse for a captured synchronous inquiry turn response" do
    skip "client.inquiry.turn_sync -> POST /inquiry/sessions/:session_id/sync is blocked until a live API response fixture is created; fixture capture was skipped to avoid additional long-running or costly agent work."
  end
end
