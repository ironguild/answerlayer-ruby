# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe AnswerLayer::DashboardsResource do
  it "routes dashboard requests with subject context" do
    client = resource_client_with({ "rows" => [] })

    client.dashboards.manifest(dashboard_id: "dash_1")
    tile_data = client.dashboards.tile_data(dashboard_id: "dash_1", tile_id: "tile_1")
    client.dashboards.parameters(dashboard_id: "dash_1", tile_id: "tile_1")
    client.dashboards.update_parameters(dashboard_id: "dash_1", tile_id: "tile_1", values: { region: "NA" }, subject_org_id: "org_1")

    expect_routes(
      { method: :get, path: "/dashboards/dash_1/manifest" },
      { method: :post, path: "/dashboards/dash_1/tiles/tile_1/data" },
      { method: :get, path: "/dashboards/dash_1/tiles/tile_1/parameters" },
      { method: :put, path: "/dashboards/dash_1/tiles/tile_1/parameters" }
    )
    expect(@request.calls).to all(include(subject: true))
    expect(@request.calls.last[:headers]).to eq("X-Subject-Org-ID" => "org_1")
    expect(tile_data).to be_a(AnswerLayer::ResultEnvelope)
  end

  it "returns a Hash for the captured dashboard manifest response" do
    client = resource_client_with(fixture("dashboards/manifest"))

    response = client.dashboards.manifest(dashboard_id: "dash_1")

    expect(response).to include("dashboard_id", "title", "tiles")
    expect(response["tiles"].first).to include("tile_id", "title", "visualization", "data_url")
  end

  it "returns a ResultEnvelope for captured dashboard tile data" do
    client = resource_client_with(fixture("dashboards/tile-data"))

    response = client.dashboards.tile_data(dashboard_id: "dash_1", tile_id: "tile_1")

    expect(response).to be_a(AnswerLayer::ResultEnvelope)
    expect(response.columns).to include("total_designated_municipalities")
    expect(response.rows.first).to eq([ 216, 12 ])
    expect(response.result_handle).to be_nil
  end

  it "returns an ApiResponse for the captured dashboard parameters response" do
    client = resource_client_with(fixture("dashboards/parameters-get"))

    response = client.dashboards.parameters(dashboard_id: "dash_1", tile_id: "tile_1")

    expect(response).to be_a(AnswerLayer::ApiResponse)
    expect(response.to_h).to be_a(Hash)
  end

  it "returns an ApiResponse for a captured dashboard parameter update response" do
    skip "client.dashboards.update_parameters -> PUT /dashboards/:dashboard_id/tiles/:tile_id/parameters is blocked until a live API response fixture is created; fixture capture currently lacks ANSWERLAYER_SUBJECT_ORG_ID."
  end
end
