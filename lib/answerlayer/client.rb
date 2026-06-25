# frozen_string_literal: true

module AnswerLayer
  class Client
    DEFAULT_BASE_URL = Configuration::DEFAULT_BASE_URL

    attr_reader :configuration

    def initialize(api_key: nil, bearer_token: nil, subject_org_id: nil, subject_user_id: nil, base_url: DEFAULT_BASE_URL, open_timeout: 10, read_timeout: 30, configuration: nil)
      @configuration = configuration || Configuration.new(
        api_key: api_key,
        bearer_token: bearer_token,
        subject_org_id: subject_org_id,
        subject_user_id: subject_user_id,
        base_url: base_url,
        open_timeout: open_timeout,
        read_timeout: read_timeout
      )
      @request = Request.new(configuration: @configuration)
    end

    def get(path, params: nil)
      request(method: :get, path: path, params: params)
    end

    def post(path, body: nil)
      request(method: :post, path: path, body: body)
    end

    def request(method:, path:, params: nil, body: nil, headers: {}, auth: :api_key, subject: false, form: nil, multipart: nil, download: false)
      @request.call(method: method, path: path, params: params, body: body, headers: headers, auth: auth, subject: subject, form: form, multipart: multipart, download: download)
    end

    def connections
      @connections ||= ConnectionsResource.new(self)
    end

    def query
      @query ||= QueryResource.new(self)
    end

    def inquiry
      @inquiry ||= InquiryResource.new(self)
    end

    def saved_queries
      @saved_queries ||= SavedQueriesResource.new(self)
    end

    def dashboards
      @dashboards ||= DashboardsResource.new(self)
    end

    def query_results
      @query_results ||= QueryResultsResource.new(self)
    end

    def semantic
      @semantic ||= SemanticResource.new(self)
    end

    def identity_broker
      @identity_broker ||= IdentityBrokerResource.new(self)
    end
  end
end
