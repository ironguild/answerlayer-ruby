# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe AnswerLayer::IdentityBrokerResource do
  it "routes token exchange and JWKS requests with the expected auth modes" do
    client = resource_client_with({ "access_token" => "placeholder-token" })

    token = client.identity_broker.exchange_token(subject_token: "placeholder-jwt")
    client.identity_broker.jwks

    expect_routes(
      { method: :post, path: "/oauth/token" },
      { method: :get, path: "/.well-known/jwks.json" }
    )
    expect(@request.calls.first[:auth]).to eq(:oauth)
    expect(@request.calls.first[:form]).to include(subject_token: "placeholder-jwt")
    expect(@request.calls.last[:auth]).to eq(:none)
    expect(token).to be_a(AnswerLayer::ApiResponse)
  end

  it "returns an ApiResponse for a captured OAuth token exchange response" do
    skip "client.identity_broker.exchange_token -> POST /oauth/token is blocked until a live API response fixture is created; fixture capture currently lacks ANSWERLAYER_IDP_JWT."
  end

  it "returns an ApiResponse for a captured JWKS response" do
    skip "client.identity_broker.jwks -> GET /.well-known/jwks.json is blocked until a successful live API response fixture is created; documentation describes a JWK set response, but current live verification returned HTTP 404 with JSON detail."
  end
end
