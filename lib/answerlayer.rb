# frozen_string_literal: true

require_relative "answerlayer/version"
require_relative "answerlayer/errors"
require_relative "answerlayer/configuration"
require_relative "answerlayer/authentication"
require_relative "answerlayer/responses"
require_relative "answerlayer/request"
require_relative "answerlayer/resources/base"
require_relative "answerlayer/resources/connections"
require_relative "answerlayer/resources/query"
require_relative "answerlayer/resources/inquiry"
require_relative "answerlayer/resources/saved_queries"
require_relative "answerlayer/resources/dashboards"
require_relative "answerlayer/resources/query_results"
require_relative "answerlayer/resources/semantic"
require_relative "answerlayer/resources/identity_broker"
require_relative "answerlayer/client"

module AnswerLayer
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
      configuration
    end

    def client
      Client.new(configuration: configuration)
    end
  end
end
