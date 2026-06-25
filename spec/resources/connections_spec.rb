# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe AnswerLayer::ConnectionsResource do
  it "routes connection requests" do
    client = resource_client_with({ "success" => true })

    client.connections.list
    client.connections.test_existing(connection_id: "conn_1")
    client.connections.schema(connection_id: "conn_1")
    client.connections.upload_csv(file: "data.csv", name: "Data")
    client.connections.upload_duckdb(file: StringIO.new("duck"), name: "Warehouse")

    expect_routes(
      { method: :get, path: "/connections/" },
      { method: :post, path: "/connections/conn_1/test_existing" },
      { method: :get, path: "/connections/conn_1/schema" },
      { method: :post, path: "/csv/upload" },
      { method: :post, path: "/duckdb/upload" }
    )
    expect(@request.calls[3][:multipart]).to include(file: "data.csv", name: "Data")
    expect(@request.calls[4][:multipart][:file]).to be_a(StringIO)
  end

  it "returns an Array for the captured connections list response" do
    client = resource_client_with(fixture("connections/list"))

    response = client.connections.list

    expect(response).to be_an(Array)
    expect(response).not_to be_empty
    expect(response).to all(be_a(Hash))

    connection = response.first
    expect(connection).to include("id", "name", "db_type", "status", "config")
    expect(connection["id"]).to be_a(String)
    expect(connection["id"]).not_to be_empty
    expect(connection["config"]).to be_a(Hash)
  end

  it "returns an ApiResponse for the captured connection test response" do
    client = resource_client_with(fixture("connections/test-existing"))

    response = client.connections.test_existing(connection_id: "conn_1")

    expect(response).to be_a(AnswerLayer::ApiResponse)
    expect(response["success"]).to be(true)
    expect(response["message"]).to eq("Connection successful")
    expect(response["latency_ms"]).to be_a(Numeric)
  end

  it "returns a Hash for the captured connection schema response" do
    client = resource_client_with(fixture("connections/schema"))

    response = client.connections.schema(connection_id: "conn_1")

    expect(response).to be_a(Hash)
    expect(response.keys).not_to be_empty
    expect(response.values.first.first).to include("name", "type", "nullable")
  end

  it "returns decoded JSON for a captured CSV upload response" do
    skip "client.connections.upload_csv -> POST /csv/upload is blocked until a live API response fixture is created; fixture capture currently lacks ANSWERLAYER_CSV_UPLOAD_FILE."
  end

  it "returns decoded JSON for a captured DuckDB upload response" do
    skip "client.connections.upload_duckdb -> POST /duckdb/upload is blocked until a live API response fixture is created; fixture capture currently lacks ANSWERLAYER_DUCKDB_UPLOAD_FILE."
  end
end
