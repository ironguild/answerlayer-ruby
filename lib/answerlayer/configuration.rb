# frozen_string_literal: true

module AnswerLayer
  class Configuration
    DEFAULT_BASE_URL = "https://app.answerlayer.io/api/v1"

    attr_accessor :api_key, :bearer_token, :subject_org_id, :subject_user_id, :base_url, :open_timeout, :read_timeout

    def initialize(api_key: nil, bearer_token: nil, subject_org_id: nil, subject_user_id: nil, base_url: nil, open_timeout: 10, read_timeout: 30)
      @api_key = explicit_or_env(api_key, "ANSWERLAYER_API_KEY")
      @bearer_token = explicit_or_env(bearer_token, "ANSWERLAYER_BEARER_TOKEN")
      @subject_org_id = subject_org_id
      @subject_user_id = subject_user_id
      @base_url = base_url || DEFAULT_BASE_URL
      @open_timeout = open_timeout
      @read_timeout = read_timeout
    end

    def validate!(auth_mode: :api_key)
      raise ConfigurationError, "base_url is required" if blank?(base_url)
      case auth_mode
      when :api_key, :oauth
        raise ConfigurationError, "api_key is required" if blank?(api_key)
      when :bearer
        raise ConfigurationError, "bearer_token is required" if blank?(bearer_token)
      when :none
        true
      else
        raise ConfigurationError, "unsupported auth mode: #{auth_mode}"
      end

      self
    end

    def base_uri
      URI(base_url)
    rescue URI::InvalidURIError
      raise ConfigurationError, "base_url must be a valid URL"
    end

    private
      def explicit_or_env(value, env_key)
        return value unless blank?(value)

        ENV[env_key]
      end

      def blank?(value)
        value.nil? || value.to_s.strip.empty?
      end
  end
end
