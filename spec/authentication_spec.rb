# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe AnswerLayer::Authentication do
  it "applies API-key headers" do
    headers = described_class.new(configuration).apply({ "Accept" => "application/json" })

    expect(headers["X-API-Key"]).to eq("api-key")
    expect(headers).not_to have_key("Authorization")
  end

  it "applies bearer-token headers without subject headers" do
    config = configuration(bearer_token: "bearer", subject_org_id: "org", subject_user_id: "user")
    headers = described_class.new(config).apply({}, mode: :bearer, subject: true)

    expect(headers["Authorization"]).to eq("Bearer bearer")
    expect(headers).not_to have_key("X-Subject-Org-ID")
    expect(headers).not_to have_key("X-Subject-User-ID")
  end

  it "applies subject headers for eligible API-key calls" do
    config = configuration(subject_org_id: "org", subject_user_id: "user")
    headers = described_class.new(config).apply({}, subject: true)

    expect(headers["X-Subject-Org-ID"]).to eq("org")
    expect(headers["X-Subject-User-ID"]).to eq("user")
  end
end
