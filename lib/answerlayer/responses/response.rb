# frozen_string_literal: true

require "json"

module AnswerLayer
  class Response
    attr_reader :status, :headers, :body

    def initialize(status:, headers:, body:)
      @status = status.to_i
      @headers = headers
      @body = body
    end

    def success?
      status.between?(200, 299)
    end

    def json?
      content_type = Array(headers["content-type"] || headers["Content-Type"]).join(";")
      content_type.include?("json") || body.to_s.strip.start_with?("{", "[")
    end

    def parsed_body
      return nil if body.nil? || body.empty?

      JSON.parse(body)
    rescue JSON::ParserError => error
      raise ResponseError, "response body was not valid JSON: #{error.message}"
    end
  end
end
