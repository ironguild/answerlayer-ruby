# frozen_string_literal: true

require "json"

module AnswerLayer
  class SSEParser
    def self.parse(stream)
      events = []
      current_type = "message"
      data_lines = []

      stream.each_line do |line|
        line = line.chomp
        if line.empty?
          events << build_event(current_type, data_lines.join("\n")) unless data_lines.empty?
          current_type = "message"
          data_lines = []
          next
        end

        field, value = line.split(":", 2)
        value = value ? value.sub(/\A /, "") : ""
        case field
        when "event"
          current_type = value
        when "data"
          data_lines << value
        end
      end

      events << build_event(current_type, data_lines.join("\n")) unless data_lines.empty?
      events
    end

    def self.build_event(type, raw_data)
      data = JSON.parse(raw_data)
      event = StreamEvent.new(type: type, data: data, raw: raw_data)
      raise StreamError.new(data["message"] || data["error"] || "stream error", event: event) if event.error?

      event
    rescue JSON::ParserError
      StreamEvent.new(type: type, data: raw_data, raw: raw_data)
    end
  end
end
