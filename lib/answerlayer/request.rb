# frozen_string_literal: true

require "json"
require "net/http"
require "uri"

module AnswerLayer
  class Request
    DEFAULT_HEADERS = {
      "Accept" => "application/json",
      "Content-Type" => "application/json"
    }.freeze

    def initialize(configuration:, authentication: Authentication.new(configuration))
      @configuration = configuration
      @authentication = authentication
    end

    FORM_HEADERS = {
      "Accept" => "application/json",
      "Content-Type" => "application/x-www-form-urlencoded"
    }.freeze

    MULTIPART_HEADERS = {
      "Accept" => "application/json",
      "Content-Type" => "multipart/form-data"
    }.freeze

    def call(method:, path:, params: nil, body: nil, headers: {}, auth: :api_key, subject: false, form: nil, multipart: nil, download: false)
      uri = build_uri(path, params)
      request = build_request(method, uri, body, headers: headers, auth: auth, subject: subject, form: form, multipart: multipart)
      response = perform(uri, request)
      parsed_response(response, download: download)
    rescue Timeout::Error, Errno::ECONNREFUSED, SocketError => error
      raise RequestError, "request failed: #{error.message}"
    end

    private
      def build_uri(path, params)
        base = @configuration.base_uri
        uri = base.dup
        request_path = path.to_s.sub(%r{\A/}, "")
        uri.path = if path.to_s.start_with?("/.well-known")
          path.to_s
        else
          base_path = base.path.to_s.sub(%r{/\z}, "")
          [base_path, request_path].reject(&:empty?).join("/")
        end
        uri.query = URI.encode_www_form(params) if params && !params.empty?
        uri
      end

      def build_request(method, uri, body, headers:, auth:, subject:, form:, multipart:)
        request_class = request_class_for(method)
        request = request_class.new(uri)
        base_headers = if form
          FORM_HEADERS
        elsif multipart
          MULTIPART_HEADERS
        else
          DEFAULT_HEADERS
        end
        @authentication.apply(base_headers.merge(headers), mode: auth, subject: subject).each { |key, value| request[key] = value }
        request.body = URI.encode_www_form(form) if form
        request.body = multipart.inspect if multipart
        request.body = JSON.generate(body) unless body.nil? || form
        request
      end

      def request_class_for(method)
        case method.to_s.downcase
        when "get" then Net::HTTP::Get
        when "post" then Net::HTTP::Post
        when "put" then Net::HTTP::Put
        when "patch" then Net::HTTP::Patch
        when "delete" then Net::HTTP::Delete
        else
          raise RequestError, "unsupported HTTP method: #{method}"
        end
      end

      def perform(uri, request)
        Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https", open_timeout: @configuration.open_timeout, read_timeout: @configuration.read_timeout) do |http|
          http.request(request)
        end
      end

      def parsed_response(raw_response, download:)
        response = Response.new(status: raw_response.code, headers: raw_response.to_hash, body: raw_response.body)
        raise_error_for(response) unless response.success?
        return download_response(response) if download && !response.json?

        response.parsed_body
      end

      def download_response(response)
        DownloadResponse.new(
          body: response.body,
          content_type: Array(response.headers["content-type"]).first,
          filename: filename_from(response.headers),
          status: response.status,
          headers: response.headers
        )
      end

      def filename_from(headers)
        disposition = Array(headers["content-disposition"]).first
        disposition&.match(/filename="?([^";]+)"?/) { |match| match[1] }
      end

      def raise_error_for(response)
        parsed = response.json? ? safe_parse(response) : nil
        message = parsed && (parsed["detail"] || parsed["error_description"] || parsed["error"])
        message ||= "request failed with status #{response.status}"

        if parsed && parsed["error"]
          raise OAuthError.new(message, error: parsed["error"], error_description: parsed["error_description"], status: response.status, body: response.body, headers: response.headers)
        end

        error_class = case response.status
        when 400 then BadRequestError
        when 401 then UnauthorizedError
        when 403 then ForbiddenError
        when 404 then NotFoundError
        when 409 then ConflictError
        when 410 then GoneError
        when 422 then UnprocessableEntityError
        when 429 then RateLimitError
        when 500..599 then ServerError
        else RequestError
        end

        raise RequestError, message if error_class == RequestError

        raise error_class.new(message, status: response.status, body: response.body, headers: response.headers)
      end

      def safe_parse(response)
        response.parsed_body
      rescue ResponseError
        nil
      end
  end
end
