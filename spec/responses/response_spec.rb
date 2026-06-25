# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe AnswerLayer::Response do
  it "normalizes status to an integer" do
    response = described_class.new(status: "201", headers: {}, body: "")

    expect(response.status).to eq(201)
  end

  it "treats 2xx statuses as successful" do
    expect(described_class.new(status: 200, headers: {}, body: "").success?).to be(true)
    expect(described_class.new(status: 204, headers: {}, body: "").success?).to be(true)
    expect(described_class.new(status: 300, headers: {}, body: "").success?).to be(false)
  end

  it "detects JSON from content type" do
    response = described_class.new(status: 200, headers: { "content-type" => [ "application/json" ] }, body: "")

    expect(response).to be_json
  end

  it "detects JSON from body shape when content type is absent" do
    object_response = described_class.new(status: 200, headers: {}, body: '{"name":"Ada"}')
    array_response = described_class.new(status: 200, headers: {}, body: '[{"name":"Ada"}]')

    expect(object_response).to be_json
    expect(array_response).to be_json
  end

  it "does not treat non-JSON bodies as JSON" do
    response = described_class.new(status: 200, headers: { "content-type" => [ "text/csv" ] }, body: "id,name\n1,Ada\n")

    expect(response).not_to be_json
  end

  it "parses JSON bodies" do
    response = described_class.new(status: 200, headers: {}, body: '{"name":"Ada"}')

    expect(response.parsed_body).to eq("name" => "Ada")
  end

  it "returns nil for empty bodies" do
    expect(described_class.new(status: 204, headers: {}, body: "").parsed_body).to be_nil
    expect(described_class.new(status: 204, headers: {}, body: nil).parsed_body).to be_nil
  end

  it "raises ResponseError for invalid JSON bodies" do
    response = described_class.new(status: 200, headers: {}, body: "not-json")

    expect { response.parsed_body }.to raise_error(AnswerLayer::ResponseError, /response body was not valid JSON/)
  end
end
