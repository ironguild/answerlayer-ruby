# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe AnswerLayer::StreamEvent do
  it "normalizes event type to a string" do
    event = described_class.new(type: :progress, data: { "step" => "starting" })

    expect(event.type).to eq("progress")
  end

  it "stores data and raw payload" do
    event = described_class.new(type: "message", data: { "ok" => true }, raw: '{"ok":true}')

    expect(event.data).to eq("ok" => true)
    expect(event.raw).to eq('{"ok":true}')
  end

  it "identifies error events" do
    expect(described_class.new(type: "error", data: {})).to be_error
    expect(described_class.new(type: "message", data: {})).not_to be_error
  end
end
