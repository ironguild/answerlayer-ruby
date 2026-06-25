# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe AnswerLayer::SavedQueriesResource do
  it "routes saved query requests and returns a ResultEnvelope for execute responses" do
    client = resource_client_with({ "rows" => [], "next_cursor" => nil, "result_handle" => nil })

    client.saved_queries.list
    client.saved_queries.create(name: "Example", sql: "select 1", connection_id: "conn_1")
    client.saved_queries.get(saved_query_id: "sq_1")
    result = client.saved_queries.execute(saved_query_id: "sq_1")
    client.saved_queries.update(saved_query_id: "sq_1", name: "Updated")
    client.saved_queries.delete(saved_query_id: "sq_1")
    client.saved_queries.create_from_inquiry_turn(inquiry_turn_id: "turn_1", name: "From inquiry")

    expect_routes(
      { method: :get, path: "/saved-queries" },
      { method: :post, path: "/saved-queries" },
      { method: :get, path: "/saved-queries/sq_1" },
      { method: :post, path: "/saved-queries/sq_1/execute" },
      { method: :patch, path: "/saved-queries/sq_1" },
      { method: :delete, path: "/saved-queries/sq_1" },
      { method: :post, path: "/saved-queries/from-inquiry-turn" }
    )
    expect(result).to be_a(AnswerLayer::ResultEnvelope)
  end

  it "returns an ApiResponse for the captured saved queries list response" do
    client = resource_client_with(fixture("saved-queries/list"))

    response = client.saved_queries.list

    expect(response).to be_a(AnswerLayer::ApiResponse)
    expect(response["saved_queries"]).to be_an(Array)
    expect(response["saved_queries"]).not_to be_empty
    expect(response["saved_queries"]).to all(be_a(Hash))

    saved_query = response["saved_queries"].first
    expect(saved_query).to include("id", "name", "sql", "visibility")
    expect(saved_query["id"]).to be_a(String)
    expect(saved_query["id"]).not_to be_empty
    expect(saved_query["sql"]).not_to be_empty
  end

  it "returns an ApiResponse for the captured saved query create response" do
    client = resource_client_with(fixture("saved-queries/create"))

    response = client.saved_queries.create(name: "Example", sql: "select 1", connection_id: "conn_1")

    expect(response).to be_a(AnswerLayer::ApiResponse)
    expect(response.to_h).to include("id", "name", "sql", "connection_id")
  end

  it "returns an ApiResponse for the captured saved query read response" do
    client = resource_client_with(fixture("saved-queries/read"))

    response = client.saved_queries.get(saved_query_id: "sq_1")

    expect(response).to be_a(AnswerLayer::ApiResponse)
    expect(response.to_h).to include("id", "name", "sql", "connection_id")
  end

  it "returns a ResultEnvelope for the captured saved query execute response" do
    client = resource_client_with(fixture("saved-queries/execute"))

    response = client.saved_queries.execute(saved_query_id: "sq_1")

    expect(response).to be_a(AnswerLayer::ResultEnvelope)
    expect(response.columns).to eq([ "ok" ])
    expect(response.rows).to eq([[ 1 ]])
    expect(response.next_cursor).to be_nil
  end

  it "returns an ApiResponse for the captured saved query update response" do
    client = resource_client_with(fixture("saved-queries/update"))

    response = client.saved_queries.update(saved_query_id: "sq_1", name: "Updated")

    expect(response).to be_a(AnswerLayer::ApiResponse)
    expect(response.to_h).to include("id", "name", "sql", "connection_id")
  end

  it "returns nil for the captured saved query delete response" do
    client = resource_client_with(fixture("saved-queries/delete"))

    response = client.saved_queries.delete(saved_query_id: "sq_1")

    expect(response).to be_nil
  end

  it "returns an ApiResponse for a captured saved query created from an inquiry turn" do
    skip "client.saved_queries.create_from_inquiry_turn -> POST /saved-queries/from-inquiry-turn is blocked until a live API response fixture is created; fixture capture currently lacks a safe ANSWERLAYER_INQUIRY_TURN_ID."
  end
end
