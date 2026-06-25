# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe AnswerLayer::ResultEnvelope do
  it "inherits ApiResponse behavior" do
    envelope = described_class.new({ "columns" => [] }, status: 200, headers: { "x-request-id" => [ "req_1" ] })

    expect(envelope).to be_a(AnswerLayer::ApiResponse)
    expect(envelope.status).to eq(200)
    expect(envelope.headers).to eq("x-request-id" => [ "req_1" ])
  end

  it "exposes result fields" do
    envelope = described_class.new({
      "columns" => [ "ok" ],
      "rows" => [[ 1 ]],
      "next_cursor" => "cursor_2",
      "result_handle" => "handle_1"
    })

    expect(envelope.columns).to eq([ "ok" ])
    expect(envelope.rows).to eq([[ 1 ]])
    expect(envelope.next_cursor).to eq("cursor_2")
    expect(envelope.result_handle).to eq("handle_1")
  end

  it "defaults missing columns and rows to empty arrays" do
    envelope = described_class.new({})

    expect(envelope.columns).to eq([])
    expect(envelope.rows).to eq([])
  end

  it "treats result cursors and handles as opaque nullable values" do
    envelope = described_class.new({ "rows" => [], "next_cursor" => "cursor", "result_handle" => nil })

    expect(envelope.next_cursor).to eq("cursor")
    expect(envelope.result_handle).to be_nil
    expect(envelope).to have_next_page
  end

  it "does not report a next page for nil or blank cursors" do
    nil_cursor = described_class.new({ "next_cursor" => nil })
    blank_cursor = described_class.new({ "next_cursor" => "" })

    expect(nil_cursor).not_to have_next_page
    expect(blank_cursor).not_to have_next_page
  end
end
