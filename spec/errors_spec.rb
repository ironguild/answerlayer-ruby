# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe AnswerLayer::Request do
  class StubbedRequest < AnswerLayer::Request
    attr_reader :last_uri, :last_request

    def initialize(configuration:, raw_response:)
      super(configuration: configuration)
      @raw_response = raw_response
    end

    private
      def perform(uri, request)
        @last_uri = uri
        @last_request = request
        @raw_response
      end
  end

  it "joins paths relative to the configured API base" do
    request = StubbedRequest.new(
      configuration: configuration,
      raw_response: FakeRawResponse.new(code: "200", body: '{"ok":true}')
    )

    request.call(method: :get, path: "/connections/")

    expect(request.last_uri.to_s).to eq("https://api.example.test/api/v1/connections/")
  end

  it "keeps well-known paths at the host root" do
    request = StubbedRequest.new(
      configuration: configuration,
      raw_response: FakeRawResponse.new(code: "200", body: '{"keys":[]}')
    )

    request.call(method: :get, path: "/.well-known/jwks.json", auth: :none)

    expect(request.last_uri.to_s).to eq("https://api.example.test/.well-known/jwks.json")
  end

  it "form encodes OAuth token exchange bodies" do
    request = StubbedRequest.new(
      configuration: configuration,
      raw_response: FakeRawResponse.new(code: "200", body: '{"ok":true}')
    )

    request.call(method: :post, path: "/oauth/token", auth: :oauth, form: { subject_token: "placeholder" })

    expect(request.last_request["Content-Type"]).to eq("application/x-www-form-urlencoded")
    expect(request.last_request.body).to eq("subject_token=placeholder")
  end

  it "returns download responses for non-JSON successful downloads" do
    request = StubbedRequest.new(
      configuration: configuration,
      raw_response: FakeRawResponse.new(
        code: "200",
        body: "id,name\n1,Ada\n",
        headers: { "content-type" => [ "text/csv" ], "content-disposition" => [ 'attachment; filename="export.csv"' ] }
      )
    )

    response = request.call(method: :post, path: "/query/conn/export", body: { query: "select 1" }, download: true)

    expect(response).to be_a(AnswerLayer::DownloadResponse)
    expect(response.filename).to eq("export.csv")
    expect(response.body).to include("Ada")
  end

  it "parses JSON errors for download endpoints" do
    request = StubbedRequest.new(
      configuration: configuration,
      raw_response: FakeRawResponse.new(code: "500", body: '{"detail":"export failed"}', headers: { "content-type" => [ "application/json" ], "x-request-id" => [ "req_1" ] })
    )

    expect {
      request.call(method: :post, path: "/query/conn/export", body: { query: "select 1" }, download: true)
    }.to raise_error(AnswerLayer::ServerError) { |error|
      expect(error.message).to eq("export failed")
      expect(error.status).to eq(500)
      expect(error.body).to eq('{"detail":"export failed"}')
      expect(error.headers["x-request-id"]).to eq([ "req_1" ])
    }
  end

  it "maps OAuth-shaped errors" do
    request = StubbedRequest.new(
      configuration: configuration,
      raw_response: FakeRawResponse.new(code: "400", body: '{"error":"invalid_request","error_description":"bad subject token"}', headers: { "content-type" => [ "application/json" ] })
    )

    expect {
      request.call(method: :post, path: "/oauth/token", auth: :oauth, form: { subject_token: "placeholder" })
    }.to raise_error(AnswerLayer::OAuthError) { |error|
      expect(error.message).to eq("bad subject token")
      expect(error.error).to eq("invalid_request")
      expect(error.error_description).to eq("bad subject token")
      expect(error.status).to eq(400)
    }
  end

  it "maps expired result handles" do
    request = StubbedRequest.new(
      configuration: configuration,
      raw_response: FakeRawResponse.new(code: "410", body: '{"detail":"expired"}')
    )

    expect {
      request.call(method: :get, path: "/query-results/handle")
    }.to raise_error(AnswerLayer::GoneError) { |error|
      expect(error.message).to eq("expired")
      expect(error.status).to eq(410)
    }
  end

  [
    [ "400", AnswerLayer::BadRequestError ],
    [ "401", AnswerLayer::UnauthorizedError ],
    [ "403", AnswerLayer::ForbiddenError ],
    [ "404", AnswerLayer::NotFoundError ],
    [ "409", AnswerLayer::ConflictError ],
    [ "422", AnswerLayer::UnprocessableEntityError ],
    [ "429", AnswerLayer::RateLimitError ],
    [ "500", AnswerLayer::ServerError ]
  ].each do |status, error_class|
    it "maps HTTP #{status} to #{error_class}" do
      request = StubbedRequest.new(
        configuration: configuration,
        raw_response: FakeRawResponse.new(code: status, body: '{"detail":"status mapped"}', headers: { "x-request-id" => [ "req_status" ] })
      )

      expect {
        request.call(method: :get, path: "/status-test")
      }.to raise_error(error_class) { |error|
        expect(error.message).to eq("status mapped")
        expect(error.status).to eq(status.to_i)
        expect(error.body).to eq('{"detail":"status mapped"}')
        expect(error.headers["x-request-id"]).to eq([ "req_status" ])
      }
    end
  end
end
