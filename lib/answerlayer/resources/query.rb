# frozen_string_literal: true

module AnswerLayer
  class QueryResource < Resource
    def execute(connection_id:, query:, params: nil, row_limit: nil, timeout: nil)
      request(method: :post, path: "/query/#{connection_id}", body: compact(query: query, params: params, row_limit: row_limit, timeout: timeout))
    end

    def validate(connection_id:, query:)
      to_api_response(request(method: :post, path: "/query/#{connection_id}/validate", body: { query: query }))
    end

    def export(connection_id:, query:, format: :csv, params: nil, row_limit: nil, timeout: nil)
      request(
        method: :post,
        path: "/query/#{connection_id}/export",
        params: { format: format },
        body: compact(query: query, params: params, row_limit: row_limit, timeout: timeout),
        download: true
      )
    end
  end
end
