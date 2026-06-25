# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe AnswerLayer::Configuration do
  it "defaults the base URL to the AnswerLayer API" do
    expect(described_class.new(api_key: "key").base_url).to eq("https://app.answerlayer.io/api/v1")
  end

  it "loads API keys from process env" do
    with_env("ANSWERLAYER_API_KEY" => "env-key") do
      expect(described_class.new.api_key).to eq("env-key")
    end
  end

  it "loads bearer tokens from process env" do
    with_env("ANSWERLAYER_BEARER_TOKEN" => "env-token") do
      expect(described_class.new.bearer_token).to eq("env-token")
    end
  end

  it "lets constructor credentials override process env" do
    with_env("ANSWERLAYER_API_KEY" => "env-key", "ANSWERLAYER_BEARER_TOKEN" => "env-token") do
      config = described_class.new(api_key: "explicit-key", bearer_token: "explicit-token")

      expect(config.api_key).to eq("explicit-key")
      expect(config.bearer_token).to eq("explicit-token")
    end
  end

  it "raises when API-key auth has no API key" do
    with_env("ANSWERLAYER_API_KEY" => nil) do
      expect { described_class.new.validate!(auth_mode: :api_key) }.to raise_error(AnswerLayer::ConfigurationError, "api_key is required")
    end
  end

  it "raises when bearer auth has no bearer token" do
    with_env("ANSWERLAYER_BEARER_TOKEN" => nil) do
      expect { described_class.new.validate!(auth_mode: :bearer) }.to raise_error(AnswerLayer::ConfigurationError, "bearer_token is required")
    end
  end

  it "parses base URLs without credential validation" do
    expect(described_class.new(base_url: "https://api.example.test/api/v1").base_uri.host).to eq("api.example.test")
  end
end
