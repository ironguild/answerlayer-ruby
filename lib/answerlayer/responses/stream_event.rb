# frozen_string_literal: true

module AnswerLayer
  class StreamEvent
    attr_reader :type, :data, :raw

    def initialize(type:, data:, raw: nil)
      @type = type.to_s
      @data = data
      @raw = raw
    end

    def error?
      type == "error"
    end
  end
end
