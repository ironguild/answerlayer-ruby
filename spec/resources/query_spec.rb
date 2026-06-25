# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe AnswerLayer::QueryResource do
  it "routes query requests and export downloads" do
    client = resource_client_with({ "columns" => [], "rows" => [] })

    client.query.execute(connection_id: "conn_1", query: "select 1")
    validation = client.query.validate(connection_id: "conn_1", query: "select 1")
    client.query.export(connection_id: "conn_1", query: "select 1", format: :csv)

    expect_routes(
      { method: :post, path: "/query/conn_1" },
      { method: :post, path: "/query/conn_1/validate" },
      { method: :post, path: "/query/conn_1/export" }
    )
    expect(validation).to be_a(AnswerLayer::ApiResponse)
    expect(@request.calls[2][:params]).to eq({ format: :csv })
    expect(@request.calls[2][:download]).to be(true)
  end

  it "returns a Hash for the captured query execute response" do
    client = resource_client_with(fixture("query/execute"))

    response = client.query.execute(connection_id: "conn_1", query: "select 1")

    expect(response).to include("columns", "rows", "row_count", "execution_time_ms")
    expect(response["columns"]).to eq([ "ok" ])
    expect(response["rows"]).to eq([[ 1 ]])
    expect(response["row_count"]).to eq(1)
  end

  it "returns an ApiResponse for the captured query validate response" do
    client = resource_client_with(fixture("query/validate"))

    response = client.query.validate(connection_id: "conn_1", query: "select 1")

    expect(response).to be_a(AnswerLayer::ApiResponse)
    expect(response["is_valid"]).to be(true)
    expect(response["query_type"]).to eq("select")
    expect(response["warning"]).to include("LIMIT")
  end

  it "returns a DownloadResponse for a captured CSV export" do
    skip "client.query.export -> POST /query/:connection_id/export?format=csv is blocked until a successful live API response fixture is created; current live verification returned HTTP 500 with JSON detail instead of downloadable CSV."
  end
end
