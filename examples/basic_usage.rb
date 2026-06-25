# frozen_string_literal: true

require "answerlayer"

client = AnswerLayer::Client.new(api_key: "example-key")

puts "Configured AnswerLayer client: #{client.class}"
puts "Connections namespace: #{client.connections.class}"
puts "Query namespace: #{client.query.class}"
