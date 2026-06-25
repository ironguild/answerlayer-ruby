# frozen_string_literal: true

module AnswerLayer
  class Error < StandardError; end

  # Local SDK errors.
  class ConfigurationError < Error; end

  class RequestError < Error; end

  class ResponseError < Error; end

  # HTTP API errors.
  class ApiError < Error
    attr_reader :status, :body, :headers

    def initialize(message, status:, body: nil, headers: nil)
      @status = status
      @body = body
      @headers = headers
      super(message)
    end
  end

  class BadRequestError < ApiError; end

  class UnauthorizedError < ApiError; end

  class ForbiddenError < ApiError; end

  class NotFoundError < ApiError; end

  class ConflictError < ApiError; end

  class GoneError < ApiError; end

  class UnprocessableEntityError < ApiError; end

  class RateLimitError < ApiError; end

  class ServerError < ApiError; end

  # OAuth-shaped API errors.
  class OAuthError < ApiError
    attr_reader :error, :error_description

    def initialize(message, error: nil, error_description: nil, status: nil, body: nil, headers: nil)
      @error = error
      @error_description = error_description
      super(message, status: status, body: body, headers: headers)
    end
  end

  # Server-sent event stream errors.
  class StreamError < Error
    attr_reader :event

    def initialize(message, event: nil)
      @event = event
      super(message)
    end
  end
end
