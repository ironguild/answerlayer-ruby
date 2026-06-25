# frozen_string_literal: true

module AnswerLayer
  class Resource
    def initialize(client)
      @client = client
    end

    private
      def request(**kwargs)
        @client.request(**kwargs)
      end

      def to_api_response(data)
        data.is_a?(ApiResponse) ? data : ApiResponse.new(data || {})
      end

      def to_result_envelope(data)
        data.is_a?(ResultEnvelope) ? data : ResultEnvelope.new(data || {})
      end

      def compact(hash)
        hash.reject { |_key, value| value.nil? }
      end
  end
end
