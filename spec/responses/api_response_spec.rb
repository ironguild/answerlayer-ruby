# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe AnswerLayer::ApiResponse do
  it "stores response data, status, and headers" do
    response = described_class.new({ "id" => "item_1" }, status: 201, headers: { "x-request-id" => [ "req_1" ] })

    expect(response.data).to eq("id" => "item_1")
    expect(response.status).to eq(201)
    expect(response.headers).to eq("x-request-id" => [ "req_1" ])
  end

  it "reads string-keyed data by string or symbol" do
    response = described_class.new({ "id" => "item_1" })

    expect(response["id"]).to eq("item_1")
    expect(response[:id]).to eq("item_1")
  end

  it "reads symbol-keyed data by string or symbol" do
    response = described_class.new({ id: "item_1" })

    expect(response["id"]).to eq("item_1")
    expect(response[:id]).to eq("item_1")
  end

  it "returns the underlying hash" do
    data = { "id" => "item_1" }
    response = described_class.new(data)

    expect(response.to_h).to equal(data)
  end
end
