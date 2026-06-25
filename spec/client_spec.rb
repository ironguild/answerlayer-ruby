# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe AnswerLayer::Client do
  it "defaults to the AnswerLayer API base URL" do
    client = described_class.new(api_key: "key")

    expect(client.configuration.base_url).to eq("https://app.answerlayer.io/api/v1")
  end

  it "constructs from env defaults" do
    with_env("ANSWERLAYER_API_KEY" => "env-key") do
      client = described_class.new

      expect(client.configuration.api_key).to eq("env-key")
    end
  end

  it "exposes public resource namespaces" do
    client = described_class.new(configuration: configuration)

    expect(client.connections).to be_a(AnswerLayer::ConnectionsResource)
    expect(client.query).to be_a(AnswerLayer::QueryResource)
    expect(client.inquiry).to be_a(AnswerLayer::InquiryResource)
    expect(client.saved_queries).to be_a(AnswerLayer::SavedQueriesResource)
    expect(client.dashboards).to be_a(AnswerLayer::DashboardsResource)
    expect(client.query_results).to be_a(AnswerLayer::QueryResultsResource)
    expect(client.semantic).to be_a(AnswerLayer::SemanticResource)
    expect(client.identity_broker).to be_a(AnswerLayer::IdentityBrokerResource)
  end

  it "keeps low-level get and post helpers available" do
    request = FakeRequest.new({ "ok" => true })
    client = client_with_request(request)

    expect(client.get("/items", params: { limit: 1 })).to eq({ "ok" => true })
    expect(client.post("/items", body: { name: "Ada" })).to eq({ "ok" => true })
    expect(request.calls.map { |call| call.slice(:method, :path) }).to eq([
      { method: :get, path: "/items" },
      { method: :post, path: "/items" }
    ])
  end
end
