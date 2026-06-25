# frozen_string_literal: true

module AnswerLayer
  class QueryResultsResource < Resource
    def get(handle:, cursor: nil, limit: nil)
      to_result_envelope(request(method: :get, path: "/query-results/#{handle}", params: compact(cursor: cursor, limit: limit)))
    end

    def release(handle:)
      request(method: :delete, path: "/query-results/#{handle}")
    end
  end
end
