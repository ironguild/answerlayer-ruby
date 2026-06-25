# frozen_string_literal: true

module AnswerLayer
  class DownloadResponse
    attr_reader :body, :content_type, :filename, :status, :headers

    def initialize(body:, content_type: nil, filename: nil, status: nil, headers: {})
      @body = body
      @content_type = content_type
      @filename = filename
      @status = status
      @headers = headers
    end
  end
end
