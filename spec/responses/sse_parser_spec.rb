# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe AnswerLayer::SSEParser do
  it "parses known and unknown events while preserving raw payloads" do
    stream = "event: progress\ndata: {\"step\":\"starting\"}\n\nevent: future\ndata: {\"x\":1}\n\n"

    events = described_class.parse(stream)

    expect(events.map(&:type)).to eq([ "progress", "future" ])
    expect(events.last.data).to eq("x" => 1)
    expect(events.last.raw).to eq('{"x":1}')
  end

  it "defaults events without an event field to message" do
    stream = "data: {\"ok\":true}\n\n"

    events = described_class.parse(stream)

    expect(events.first.type).to eq("message")
    expect(events.first.data).to eq("ok" => true)
  end

  it "combines multiline data fields" do
    stream = "event: message\ndata: first\ndata: second\n\n"

    events = described_class.parse(stream)

    expect(events.first.data).to eq("first\nsecond")
    expect(events.first.raw).to eq("first\nsecond")
  end

  it "keeps non-JSON data as a raw string" do
    stream = "event: message\ndata: plain text\n\n"

    events = described_class.parse(stream)

    expect(events.first.data).to eq("plain text")
    expect(events.first.raw).to eq("plain text")
  end

  it "parses a final event without a trailing blank line" do
    stream = "event: progress\ndata: {\"step\":\"done\"}"

    events = described_class.parse(stream)

    expect(events.first.type).to eq("progress")
    expect(events.first.data).to eq("step" => "done")
  end

  it "raises stream errors for error events" do
    stream = "event: error\ndata: {\"message\":\"failed\"}\n\n"

    expect { described_class.parse(stream) }.to raise_error(AnswerLayer::StreamError, "failed")
  end

  it "uses fallback error fields for stream errors" do
    stream = "event: error\ndata: {\"error\":\"boom\"}\n\n"

    expect { described_class.parse(stream) }.to raise_error(AnswerLayer::StreamError, "boom")
  end
end
