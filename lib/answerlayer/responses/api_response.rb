# frozen_string_literal: true

module AnswerLayer
  class ApiResponse
    attr_reader :data, :status, :headers

    def initialize(data = {}, status: nil, headers: {})
      @data = data
      @status = status
      @headers = headers
    end

    def [](key)
      data[key.to_s] || data[key.to_sym]
    end

    def to_h
      data
    end
  end
end
