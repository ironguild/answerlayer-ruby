# frozen_string_literal: true

module AnswerLayer
  class Authentication
    def initialize(configuration)
      @configuration = configuration
    end

    def apply(headers, mode: :api_key, subject: false)
      @configuration.validate!(auth_mode: mode)
      authenticated = headers.dup

      case mode
      when :api_key, :oauth
        authenticated["X-API-Key"] = @configuration.api_key
      when :bearer
        authenticated["Authorization"] = "Bearer #{@configuration.bearer_token}"
      when :none
        authenticated
      else
        raise ConfigurationError, "unsupported auth mode: #{mode}"
      end

      apply_subject_headers(authenticated) if subject && mode != :bearer
      authenticated
    end

    private
      def apply_subject_headers(headers)
        headers["X-Subject-Org-ID"] = @configuration.subject_org_id if present?(@configuration.subject_org_id)
        headers["X-Subject-User-ID"] = @configuration.subject_user_id if present?(@configuration.subject_user_id)
      end

      def present?(value)
        !value.nil? && !value.to_s.strip.empty?
      end
  end
end
