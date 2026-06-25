# frozen_string_literal: true

module AnswerLayer
  class SavedQueriesResource < Resource
    def list
      to_api_response(request(method: :get, path: "/saved-queries"))
    end

    def create(name:, sql:, connection_id:, description: nil, visibility: nil)
      to_api_response(request(method: :post, path: "/saved-queries", body: compact(name: name, sql: sql, connection_id: connection_id, description: description, visibility: visibility)))
    end

    def get(saved_query_id:)
      to_api_response(request(method: :get, path: "/saved-queries/#{saved_query_id}"))
    end

    def execute(saved_query_id:, params: nil, row_limit: nil, timeout: nil)
      to_result_envelope(request(method: :post, path: "/saved-queries/#{saved_query_id}/execute", body: compact(params: params, row_limit: row_limit, timeout: timeout)))
    end

    def update(saved_query_id:, **attributes)
      to_api_response(request(method: :patch, path: "/saved-queries/#{saved_query_id}", body: attributes))
    end

    def delete(saved_query_id:)
      request(method: :delete, path: "/saved-queries/#{saved_query_id}")
    end

    def create_from_inquiry_turn(inquiry_turn_id:, name:, description: nil, visibility: nil)
      to_api_response(request(method: :post, path: "/saved-queries/from-inquiry-turn", body: compact(inquiry_turn_id: inquiry_turn_id, name: name, description: description, visibility: visibility)))
    end
  end
end
