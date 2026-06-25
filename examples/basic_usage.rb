# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "answerlayer"

client = AnswerLayer::Client.new(api_key: "example-key", base_url: "https://api.example.test/api/v1")

puts "Configured AnswerLayer client: #{client.class}"
puts "Connections namespace: #{client.connections.class}"
puts "Query namespace: #{client.query.class}"
