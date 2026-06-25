# frozen_string_literal: true

require "json"
require "stringio"

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "answerlayer"

module SpecHelpers
  FakeRawResponse = Struct.new(:code, :body, :headers, keyword_init: true) do
    def to_hash
      headers || { "content-type" => [ "application/json" ] }
    end
  end

  class FakeRequest
    attr_reader :calls

    def initialize(result = {})
      @result = result
      @calls = []
    end

    def call(method:, path:, params: nil, body: nil, headers: {}, auth: :api_key, subject: false, form: nil, multipart: nil, download: false)
      calls << {
        method: method,
        path: path,
        params: params,
        body: body,
        headers: headers,
        auth: auth,
        subject: subject,
        form: form,
        multipart: multipart,
        download: download
      }
      @result
    end
  end

  def configuration(**overrides)
    AnswerLayer::Configuration.new(**{ api_key: "api-key", base_url: "https://api.example.test/api/v1" }.merge(overrides))
  end

  def with_env(values)
    old_values = values.keys.to_h { |key| [ key, ENV[key] ] }
    values.each { |key, value| value.nil? ? ENV.delete(key) : ENV[key] = value }
    yield
  ensure
    old_values.each { |key, value| value.nil? ? ENV.delete(key) : ENV[key] = value }
  end

  def capture_stdout
    original = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = original
  end

  def fixture(path)
    fixture_path = File.expand_path("fixtures/#{path}.json", __dir__)
    JSON.parse(File.read(fixture_path))
  end

  def resource_client_with(result = {})
    @request = FakeRequest.new(result)
    client_with_request(@request)
  end

  def expect_routes(*routes)
    expect(@request.calls.map { |call| call.slice(:method, :path) }).to eq(routes)
  end

  def client_with_request(request, config: configuration)
    AnswerLayer::Client.new(configuration: config).tap do |client|
      client.instance_variable_set(:@request, request)
    end
  end
end

FakeRequest = SpecHelpers::FakeRequest
FakeRawResponse = SpecHelpers::FakeRawResponse

RSpec.configure do |config|
  config.include SpecHelpers

  config.after do
    AnswerLayer.configuration = AnswerLayer::Configuration.new
  end
end
