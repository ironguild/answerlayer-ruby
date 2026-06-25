# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe AnswerLayer do
  it "exposes a version" do
    expect(described_class::VERSION).not_to be_nil
  end

  it "configures global configuration" do
    described_class.configure do |config|
      config.api_key = "configured-key"
      config.base_url = "https://api.example.test/api/v1"
    end

    expect(described_class.configuration.api_key).to eq("configured-key")
    expect(described_class.configuration.base_url).to eq("https://api.example.test/api/v1")
  end

  it "builds a client from global configuration" do
    described_class.configure { |config| config.api_key = "configured-key" }

    expect(described_class.client).to be_a(AnswerLayer::Client)
  end
end
