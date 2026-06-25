# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe AnswerLayer::QueryResultsResource do
  it "routes query result requests" do
    client = resource_client_with({ "rows" => [], "next_cursor" => "cursor_2", "result_handle" => "handle_1" })

    result = client.query_results.get(handle: "handle_1", cursor: "cursor_1", limit: 10)
    client.query_results.release(handle: "handle_1")

    expect_routes(
      { method: :get, path: "/query-results/handle_1" },
      { method: :delete, path: "/query-results/handle_1" }
    )
    expect(@request.calls.first[:params]).to eq({ cursor: "cursor_1", limit: 10 })
    expect(result).to be_a(AnswerLayer::ResultEnvelope)
    expect(result.next_cursor).to eq("cursor_2")
  end

  it "returns a ResultEnvelope for a captured query result page response" do
    skip "client.query_results.get -> GET /query-results/:handle is blocked until a live API response fixture is created; fixture capture currently lacks ANSWERLAYER_RESULT_HANDLE."
  end

  it "returns nil for the captured query result release response" do
    skip "client.query_results.release -> DELETE /query-results/:handle is blocked until a live API response fixture is created; fixture capture currently lacks ANSWERLAYER_DELETE_RESULT_HANDLE."
  end
end
